extends Node2D
var shader_material: ShaderMaterial
var shader_active: bool = false
@onready var cardManager = $"../CardManager"
@onready var playerHand = $PlayerHand
@onready var color_rect = $ColorRect

func _ready() -> void:
	shader_material = color_rect.material
	shader_material.set_shader_parameter("opacity", 0.0)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("exit")):
		get_tree().quit()
	elif(event.is_action_pressed("test")):
		cardManager.returnCards()
	elif(event.is_action_pressed("restart")):
		playerHand.deck = playerHand.oldDeck
		playerHand.oldDeck = []
		var cards = get_tree().get_nodes_in_group("inPlay")
		var cardslot = get_tree().get_nodes_in_group("card_slot")
		for card in cards:
			card.checking = false
			card.isInSlot = false
			card.remove_from_group("inPlay")
			card.add_to_group("draggable")
		for slot in cardslot:
			slot.add_to_group("card_slot_empty")
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect, "modulate:a", 0, 0.3)
		shader_material.set_shader_parameter("opacity", 0.0)
		playerHand.startGame()
