extends Area2D

@onready var cardBase = $".."
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
signal hovered
signal hovered_off

func _ready() -> void:
	screen_size = get_viewport().size
	screen_center = get_viewport().size / 2
	playerHandRef = $"../../../PlayerHand"
	cardManager = $"../../../CardManager"
	add_to_group("draggable")
	add_to_group("inHand")


func _process(_delta: float) -> void:
	if dragging:
		cardBase.position = get_global_mouse_position() + offset


	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		var mouse_pos = get_global_mouse_position()
		if event is InputEventMouseButton:
			if(Input.is_action_just_pressed("leftClick")):
				startingPosition = cardBase.position
				if not isInSlot:
					dragging = true
					offset = cardBase.position - get_global_mouse_position()
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
				print("hello")
				#moveCardToCenter()
				
func checkForSlot():
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("card_slots"):
			position = area.get_parent().position
			area.get_parent().hasCard = true
			remove_from_group("inHand")
			add_to_group("inPlay")
			playerHandRef.remove_card_from_hand(self)
			remove_from_group("draggable")
			add_to_group("inPlay")
			isInSlot = true;
			if playerHandRef.playerHand.size() == 0:
				cardManager.playGame()
			break
	if not isInSlot:
		returnToHand()
		
func moveCardToCenter():
	var tween = get_tree().create_tween()
	tween.tween_property(cardBase, "position", screen_center, 0.3)
	pass

func returnToHand():
	var tween = get_tree().create_tween()
	tween.tween_property(cardBase, "position", startingPosition, 0.3)
	add_to_group("draggable")
				
func _on_area_2d_mouse_entered() -> void:
	if(!isInSlot):
		highlight_card(cardBase, true)

func _on_area_2d_mouse_exited() -> void:
	if(!isInSlot):
		highlight_card(cardBase, false)

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(0.511, 0.509)
		card.z_index = 2
	else:
		card.scale = Vector2(0.411, 0.409)
		card.z_index = 1
