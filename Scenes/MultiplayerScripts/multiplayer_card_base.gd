extends Node2D
var card_being_dragged: Node2D = null
var screen_size: Vector2
var screen_center: Vector2
var dragging = false
var checking = false
var offset = Vector2()
var startingPosition
var playerHandRef
var cardManager
var isInSlot = false
var removeCard = false
signal hovered
signal hovered_off
var playerHand
var imageLink

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	screen_center = get_viewport().get_visible_rect().size / 2
	add_to_group("draggable")
	add_to_group("inHand")
	playerHand = get_node("/root/Main/PlaySpace/PlayerHand")
	cardManager = get_node("/root/Main/CardManager")
	
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + offset
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var mouse_pos = get_global_mouse_position()
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("leftClick")):
			startingPosition = position
			if not isInSlot:
				dragging = true
				offset = position - get_global_mouse_position()
			elif isInSlot:
				checking = true
		elif(Input.is_action_just_released("leftClick")):
			dragging = false
			checking = false
			if not isInSlot:
				checkForSlot()
		if dragging and is_in_group("draggable"):
			position = get_global_mouse_position() + offset
		if checking and is_in_group("inPlay"):
			if cardManager.cardname == self.name:
				removeCard = true
				checkNearbyCards()
				
func checkForSlot():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("card_slot_empty"):
			position = playerHand.to_local(area.get_parent().position)
			area.get_parent().fillCardSlot()
			remove_from_group("inHand")
			add_to_group("inPlay")
			remove_from_group("draggable")
			add_to_group("inPlay")
			isInSlot = true;
			if multiplayer.is_server():
				cardManager.rpc("placeCardInClientOpponentZone", name, imageLink, area.get_parent().name)
				playerHand.playerHand.erase(self)
			elif !multiplayer.is_server():
				cardManager.rpc("placeCardInServerOpponentZone", name, imageLink, area.get_parent().name)
				playerHand.playerHand.erase(self)
			if playerHand.playerHand.size() == 0:
				if multiplayer.is_server():
					cardManager.player1Ready = true
					cardManager.checkReady()
				elif not multiplayer.is_server():
					cardManager.rpc("readyClient")
	if not isInSlot:
		returnCardToHand()
		
func returnCardToHand():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", startingPosition, 0.3)
	add_to_group("draggable")

func checkNearbyCards():
	pass
	
func _on_area_2d_mouse_entered() -> void:
	if(!isInSlot):
		highlight_card(self, true)

func _on_area_2d_mouse_exited() -> void:
		highlight_card(self, false)

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(0.511, 0.509)
		card.z_index = 2
	else:
		card.scale = Vector2(0.411, 0.409)
		card.z_index = 1
