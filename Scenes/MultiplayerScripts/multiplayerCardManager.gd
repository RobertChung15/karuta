extends Node
const card_scene = "res://Scenes/MultiplayerScripts/multiplayer_card_base.tscn"
var deck = [{"name": "Bo Peep", "image": "BoPeep"}, 
{"name": "Humpty Dumpty", "image": "HumptyDumpty"}, 
{"name": "Red Riding Hood", "image": "RedRiding"}, 
{"name": "Three Little Pigs", "image": "threelittlepigs"}]
var oldDeck = []
var playerHand
var player_hands
var handSize = 2
var cardpool = []
var startingPosition
var imageLink
var cardScene
var player1Ready = false
var player2Ready = false
var centre_screen_x
var countdown = 3;
var displayText;
var timer;
var cardname;
var stopwatch;
var winner_found = false;

func _ready() -> void:
	stopwatch = $"../PlaySpace/stopwatch"
	cardScene = preload(card_scene)
	var visible_rect = get_viewport().get_visible_rect()
	centre_screen_x = visible_rect.position.x + (visible_rect.size.x / 2)

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
	opponentCardObject.add_to_group("inPlay")
	opponentCardObject.isInSlot = true
	opponentCardObject.imageLink = opponentCardImageLink
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
	opponentCardObject.imageLink = opponentCardImageLink
	opponentCardObject.get_node("CardImage").texture = load(opponentCardImageLink)
	opponentCardObject.add_to_group("inPlay")
	opponentCardObject.isInSlot = true
	var chosenCardSlot = opponentPlayspace.get_node("CardSlots/" + cardSlotName)
	var opponentCards = opponentPlayspace.get_node("Cards")
	opponentCards.add_child(opponentCardObject)
	opponentCardObject.position = chosenCardSlot.position

@rpc("call_remote")
func startReading() -> void:
	displayText = $"../PlaySpace/HBoxContainer/DisplayText"
	displayText.text = "3"
	displayText.visible = true
	timer = $Timer
	timer.start()

@rpc("any_peer")
func readyClient() -> void:
	player2Ready = true
	checkReady()
	
func checkReady() -> void:
	if(player1Ready and player2Ready):
		countdown = 3
		startReading()
		rpc("startReading")
	
func _on_timer_timeout() -> void:
	countdown -= 1
	if(countdown > 0):
		displayText.text = str(countdown)
		timer.start()
	else:
		if(cardpool.size() > 0):
			if multiplayer.is_server():
				cardname = pickRandomCard()
				removeCardFromPool(cardname)
				displaySelectedPoem(cardname)
				rpc("displaySelectedPoem", cardname)
		timer.stop()
	
func pickRandomCard() -> String:
	var randomNumber = randi() % (cardpool.size())
	var cardname = cardpool[randomNumber]
	return cardname
	
func removeCardFromPool(cardname: String) -> void:
	if cardpool.has(cardname):
		cardpool.erase(cardname)

@rpc("call_remote")
func displaySelectedPoem(selectedCardName: String) -> void:
	displayText.text = selectedCardName
	winner_found = false

@rpc("any_peer")
func checkWinner(player_id: int) -> void:
	print(player_id)
	if not winner_found:
		winner_found = true
		print("Winner: Player ", player_id)
		displayText.text = "Winner: Player " + str(player_id)
