extends Node

var cardpool = []
var displayText: Label
var timer: Timer
var countdownTime: int = 0
var cardname
var start = false;
var color_rect: ColorRect

func _ready() -> void:
	color_rect = $"../ColorRect"
	color_rect.size = get_viewport().get_visible_rect().size
	#color_rect.color = Color(0, 0, 0, 0)
	color_rect.color = Color.mix
	color_rect.z_index = 1
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
	
func callJudge() -> void:
	displayText.text = "Correct Card"
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0.5), 0.5)
	timer.connect("timeout", returnToNormal)
	
func returnToNormal() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 0.5)
	
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
