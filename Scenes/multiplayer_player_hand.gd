extends Node2D
var playerHand = []
var card_width = 100
var hand_y_position
var centre_screen_x
@onready var deck = $"../Deck"

func _ready() -> void:
	hand_y_position = get_viewport().size.y / 2
	var visible_rect = get_viewport().get_visible_rect()
	centre_screen_x = visible_rect.position.x + (visible_rect.size.x / 2)
	print(centre_screen_x)

func add_card_to_hand(card):
	print("adding")
	if card not in playerHand:
		playerHand.insert(0, card)
		var startingPosition = deck.position
		update_hand_position(startingPosition)
		
func update_hand_position(startingPosition):
	for i in range(playerHand.size()):
		var card = playerHand[i]
		card.position = Vector2(20 * i, 20 * i)
		animate_card_to_position(Vector2(0, 0), card, Vector2(540, 0))
		
func calculateHandPosition(index):
	var totalWidth = (playerHand.size() - 1) * card_width
	var x_offset = centre_screen_x + index * card_width - totalWidth / 2
	return x_offset
	
func animate_card_to_position(startingPosition, card, new_position):
	card.position = startingPosition
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.3)
