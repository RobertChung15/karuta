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

	for i in handSize * 2:
		var randNumber = randi() % (deck.size())
		var cardname = deck[randNumber]["name"]
		var image = deck[randNumber]["image"]
		cardpool.append(cardname)

		oldDeck.append(deck[randNumber])
		deck.erase(deck[randNumber])

		rpc("dealCardServer", new_card)
	#rpc("hello")
	
@rpc("authority")
func dealCardServer() -> void:
	var card = preload(card_scene)
	var new_card = card.instantiate()
	var cardImagePath = str("res://Cards/" + image + ".png")
	new_card.get_node("CardImage").texture = load(cardImagePath)
	
@rpc("call_remote")
func dealCard(new_card) -> void:
	print("client")

	
