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

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	screen_center = get_viewport().get_visible_rect().size / 2
	playerHandRef = $"../../PlayerHand"
	cardManager = $"../../CardManager"
	add_to_group("draggable")
	add_to_group("inHand")

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

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + offset

func checkNearbyCards():
	var cards = get_tree().get_nodes_in_group("inPlay")
	for obj in cards:
		if (self.position.distance_to(obj.position) < 200):
			impulseCard(obj)
	
func impulseCard(obj):
	var mouse_pos = get_global_mouse_position()
	var direction = (obj.position - mouse_pos).normalized()
	var distance = 50
	var rotation_angle = randf_range(-30, 30)
	var original_position = obj.position
	#move card to position
	var tween = get_tree().create_tween()
	var endPosition = obj.position + (direction * distance)
	tween.tween_property(obj, "position", endPosition, 0.1)
	tween.tween_property(obj, "rotation", deg_to_rad(rotation_angle), 0.05)
	cardManager.pauseTime()
	var timer: Timer = obj.get_node("Timer")
	timer.timeout.connect(resetPosition.bind(obj, original_position))
	timer.start()

func resetPosition(obj, original_position):
	if obj.removeCard:
		moveCardToCenter()
		cardManager.callJudge()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(obj, "position", original_position, 0.1)
		tween.tween_property(obj, "rotation", 0, 0.1)
	
func checkForSlot():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("card_slot_empty"):
			position = area.get_parent().position
			area.get_parent().fillCardSlot()
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
	self.z_index = 2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", screen_center, 0.3)
	tween.tween_property(self, "rotation", 0, 0.05)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	$AnimationPlayer.play("selected")
	

func returnToHand():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", startingPosition, 0.3)
	add_to_group("draggable")
				
func _on_area_2d_mouse_entered() -> void:
	if(!isInSlot):
		highlight_card(self, true)

func _on_area_2d_mouse_exited() -> void:
	if(!isInSlot):
		highlight_card(self, false)

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(0.511, 0.509)
		card.z_index = 2
	else:
		card.scale = Vector2(0.411, 0.409)
		card.z_index = 1
