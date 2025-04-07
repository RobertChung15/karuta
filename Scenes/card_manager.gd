extends Node

var cardpool = []
var displayText: Label
var timer: Timer
var countdownTime: int = 2
var cardname
var start = false;

func _ready() -> void:
	displayText = $"../DisplayText"
	displayText.text = "2"
	timer =  $Timer
	

func addToCardPool(cardname: String) -> void:
	cardpool.append(cardname)
	
func pickRandomCard() -> String:
	var randomNumber = randi() % (cardpool.size())
	var cardname = cardpool[randomNumber]
	return cardname
	
func removeCardFromPool(cardname: String) -> void:
	if cardpool.has(cardname):
		cardpool.erase(cardname)

func playGame() -> void:
	start = true;
	timer.start()

func _on_timer_timeout() -> void:
	countdownTime -= 1
	displayText.text = str(countdownTime)
	if(countdownTime <= 0):
		cardname = pickRandomCard()
		removeCardFromPool(cardname)
		displayText.text = cardname
		timer.stop()
	else:
		timer.start()
