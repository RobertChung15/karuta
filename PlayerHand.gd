extends Node2D

const hand_size = 4
const card_scene = "res://card_base.tscn"
const card_width = 100
var playerHand = []
var centre_screen_x
var hand_y_position = 590
var player_hand_reference
var deck = ["one", "two", "three", "four"]

# Called when the node enters the scene tree for the first time.
func _ready():
	centre_screen_x = get_viewport().size.x / 2


func startGame():
	var card = preload(card_scene)
	for i in range(hand_size):
		var randomNumber = randi() % (deck.size())
		print(randomNumber)
		var new_card = card.instantiate()
		new_card.name = deck[randomNumber]
		var cardImagePath = str("res://Cards/" + new_card.name + ".png")
		print(cardImagePath)
		new_card.get_node("CardImage").texture = load(cardImagePath)
		deck.erase(randomNumber)
		$"../CardManager".add_child(new_card)
		add_card_to_hand(new_card)	
		
func add_card_to_hand(card):
	if card not in playerHand:
		playerHand.insert(0, card)
		update_hand_position()
	else:
		animation_card_to_position(card, card.startingPosition)
	
func update_hand_position():
	for i in range(playerHand.size()):
		var new_position = Vector2(calculateHandPosition(i), hand_y_position)
		var card = playerHand[i]
		card.startingPosition = new_position
		animation_card_to_position(card, new_position)
		
func calculateHandPosition(index):
	var totalWidth = (playerHand.size() - 1) * card_width
	var x_offset = centre_screen_x + index * card_width - totalWidth / 2
	return x_offset	
	
func animation_card_to_position(card, new_position):
	card.position = $"../Deck".position
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.3)
	pass
	
func remove_card_from_hand(card):
	if card in playerHand:
		playerHand.erase(card)
		update_hand_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
