extends Node
const card_scene = "res://Scenes/card_base.tscn"
var deck = [{"name": "Bo Peep", "image": "BoPeep"}, 
{"name": "Humpty Dumpty", "image": "HumptyDumpty"}, 
{"name": "Red Riding Hood", "image": "RedRiding"}, 
{"name": "Three Little Pigs", "image": "threelittlepigs"}]
var oldDeck = []
var playerHand
var opponentHand
var player_hands
var handSize = 2
var cardpool = []

func startGame() -> void:
	rpc("dealCard")
	
@rpc("call_local", "any_peer")
func dealCard() -> void:
	var card = preload(card_scene)
	for i in handSize:
		var randomNumber = randi() % (deck.size())
		var new_card = card.instantiate()
		new_card.name = deck[randomNumber]["name"]
		var image = deck[randomNumber]["image"]
		var cardImagePath = str("res://Cards/" + image + ".png")
		new_card.get_node("CardImage").texture = load(cardImagePath)
		oldDeck.append(deck[randomNumber])
		deck.erase(deck[randomNumber])
		cardpool.append(new_card.name)
		add_child(new_card)
		new_card.position = get_viewport().get_visible_rect().size / 2
	
	
