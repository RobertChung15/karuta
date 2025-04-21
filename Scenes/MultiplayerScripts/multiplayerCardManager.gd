extends Node
const card_scene = "res://Scenes/MultiplayerScripts/multiplayer_card_base.tscn"
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
var startingPosition
var imageLink
var cardScene
var player1Ready = false
var player2Ready = false

func _ready() -> void:
	cardScene = preload(card_scene)

func startGame() -> void:
	for i in handSize * 2:
		var randNumber = randi() % (deck.size())
		var cardname = deck[randNumber]["name"]
		var image = deck[randNumber]["image"]
		cardpool.append(cardname)
		oldDeck.append(deck[randNumber])
		deck.erase(deck[randNumber])
		if i % 2 == 0:
			dealCardServer(cardname, image, i)
		elif i % 2 == 1:
			rpc("dealCardClient", cardname, image, i)
	
	
func dealCardServer(cardname, image, i) -> void:
	var player1Hand = $"../PlaySpace/PlayerHand"
	var new_card = cardScene.instantiate()
	new_card.name = cardname
	imageLink = str("res://Cards/" + image + ".png")
	new_card.imageLink = imageLink
	new_card.get_node("CardImage").texture = load(imageLink)
	player1Hand.add_child(new_card)
	player1Hand.add_card_to_hand(new_card)
	
@rpc("call_remote")
func dealCardClient(cardname, image, i) -> void:
	var player1Hand = $"../PlaySpace/PlayerHand"
	var new_card = cardScene.instantiate()
	new_card.name = cardname
	imageLink = str("res://Cards/" + image + ".png")
	new_card.imageLink = imageLink
	new_card.get_node("CardImage").texture = load(imageLink)
	player1Hand.add_child(new_card)
	player1Hand.add_card_to_hand(new_card)
	
@rpc("call_remote")
func placeCardInClientOpponentZone(opponentCardName, opponentCardImageLink, cardSlotName):
	var opponentPlayspace = $"../OpponentPlayerSpace"
	var opponentCardObject = cardScene.instantiate()
	opponentCardObject.remove_from_group("draggable")
	opponentCardObject.name = opponentCardName
	opponentCardObject.get_node("CardImage").texture = load(opponentCardImageLink)
	var chosenCardSlot = opponentPlayspace.get_node("CardSlots/" + cardSlotName)
	var opponentCards = opponentPlayspace.get_node("Cards")
	opponentCards.add_child(opponentCardObject)
	opponentCardObject.position = chosenCardSlot.position
	
@rpc("any_peer")
func placeCardInServerOpponentZone(opponentCardName, opponentCardImageLink, cardSlotName):
	var opponentPlayspace = $"../OpponentPlayerSpace"
	var opponentCardObject = cardScene.instantiate()
	opponentCardObject.name = opponentCardName
	opponentCardObject.get_node("CardImage").texture = load(opponentCardImageLink)
	var chosenCardSlot = opponentPlayspace.get_node("CardSlots/" + cardSlotName)
	var opponentCards = opponentPlayspace.get_node("Cards")
	opponentCards.add_child(opponentCardObject)
	opponentCardObject.position = chosenCardSlot.position

@rpc("any_peer", "call_remote")
func startReading() -> void:
	var displayText = $"../PlaySpace/DisplayText"
	displayText.text = "Starting"
	displayText.visible = true

@rpc("any_peer")
func readyClient() -> void:
	player2Ready = true
	checkReady()
	
func checkReady() -> void:
	if(player1Ready and player2Ready):
		startReading()
	

	
