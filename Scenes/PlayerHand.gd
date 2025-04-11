extends Node2D

const hand_size = 4
const card_scene = "res://Scenes/card_base.tscn"
const card_width = 100
var playerHand = []
var centre_screen_x
var hand_y_position
var player_hand_reference
var deck = [{"name": "Bo Peep", "image": "BoPeep"}, 
{"name": "Humpty Dumpty", "image": "HumptyDumpty"}, 
{"name": "Red Riding Hood", "image": "RedRiding"}, 
{"name": "Three Little Pigs", "image": "threelittlepigs"}]
var oldDeck = []
var cardManager
var gameStarted = false
@onready var displayText = $"../DisplayText"
@onready var endText = $"../endText"
@onready var averageTime =  $"../averageTime"

func _ready():
	var visible_rect = get_viewport().get_visible_rect()
	centre_screen_x = visible_rect.position.x + (visible_rect.size.x / 2)
	hand_y_position = get_viewport().size.y / 2
	cardManager = $"../CardManager"

func startGame():
	displayText.text = ""
	endText.visible = false
	averageTime.visible = false
	var card = preload(card_scene)
	for i in range(hand_size):
		var randomNumber = randi() % (deck.size())
		var new_card = card.instantiate()
		new_card.name = deck[randomNumber]["name"]
		cardManager.addToCardPool(new_card.name)
		var image = deck[randomNumber]["image"]
		var cardImagePath = str("res://Cards/" + image + ".png")
		oldDeck.append(deck[randomNumber])
		deck.erase(deck[randomNumber])
		new_card.get_node("CardImage").texture = load(cardImagePath)
		$"../CardManager".add_child(new_card)
		add_card_to_hand(new_card)	
		new_card.get_node("AnimationPlayer").play("flip")
	gameStarted = true
	
func add_card_to_hand(card):
	if card not in playerHand:
		playerHand.insert(0, card)
		if not gameStarted:
			var startingPosition = $"../Deck".position
			update_hand_position(startingPosition)
		elif gameStarted:
			var startingPosition = card.position
			update_hand_position(startingPosition)
	
func update_hand_position(startingPosition):
	for i in range(playerHand.size()):
		var new_position = Vector2(calculateHandPosition(i), hand_y_position)
		var card = playerHand[i]
		card.startingPosition = new_position
		animation_card_to_position(startingPosition, card, card.startingPosition)
		
func calculateHandPosition(index):
	var totalWidth = (playerHand.size() - 1) * card_width
	var x_offset = centre_screen_x + index * card_width - totalWidth / 2
	return x_offset	
	
func animation_card_to_position(startingPosition, card, new_position):
	card.position = startingPosition
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.3)
	
func remove_card_from_hand(card):
	if card in playerHand:
		playerHand.erase(card)
