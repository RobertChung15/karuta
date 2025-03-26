extends Node2D

const hand_size = 2
const card_scene = "res://card_base.tscn"
const card_width = 200
var playerHand = []
var centre_screen_x

# Called when the node enters the scene tree for the first time.
func _ready():
	centre_screen_x = get_viewport().size.x / 2
	var card = preload(card_scene)
	for i in range(hand_size):
		var new_card = card.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
		
		
func add_card_to_hand(card):
	playerHand.insert(0, card)
	update_hand_position()
	
func update_hand_position():
	for i in range(playerHand.size()):
		var cardPosition = calculateHandPosition(i)
		
func calculateHandPosition(index):
	var totalWidth = (playerHand.size() - 1) * card_width
	var x_offset = centre_screen_x + (index * card_width) - totalWidth / 2
	return x_offset	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
