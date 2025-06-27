extends Node
var cardpool = []
var cardTime = []
var displayText: Label
var timeText: Label
var time: Label
var timer: Timer
var countTime = 3
var countdownTime: int = countTime
var cardname
var start = false;
var color_rect: ColorRect
var shader_material: ShaderMaterial
var shader_active: bool = false
var stopwatch: Stopwatch
var playerHand
var opponentHand
var endText
var averageTime

func _ready() -> void:
	playerHand = $"../PlayerHand"
	color_rect = $"../ColorRect"
	endText = $"../endText"
	averageTime = $"../averageTime"
	color_rect.size = get_viewport().get_visible_rect().size
	color_rect.z_index = 1
	shader_material = color_rect.material
	color_rect.modulate.a = 0
	shader_material.set_shader_parameter("opacity", 0.0)
	displayText = $"../DisplayText"
	displayText.text = "2"
	displayText.visible = false
	displayText.position.x = (get_viewport().get_visible_rect().size.x - displayText.size.x) / 2
	timeText = $"../timeText"
	timeText.visible = false
	timeText.position.x = (get_viewport().get_visible_rect().size.x - timeText.size.x) / 2
	timeText.position.y = (4* (get_viewport().get_visible_rect().size.y - timeText.size.y)) / 5
	time = $"../time"
	time.visible = false
	time.position.x = ((get_viewport().get_visible_rect().size.x - time.size.x) / 2) - 20
	time.position.y = (9 * (get_viewport().get_visible_rect().size.y - time.size.y)) / 10
	timer =  $Timer
	stopwatch = $"../stopwatch"
	
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
	displayText.visible = true
	timer.start()
	
func callJudge() -> void:
	displayText.text = "Correct Card"
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1, 0.3)
	shader_material.set_shader_parameter("opacity", 1.0)
	color_rect.modulate.a = 255
	var newTimer = Timer.new()
	add_child(newTimer)
	timeText.visible = true
	timeText.z_index = 2
	time.visible = true
	time.z_index = 2
	newTimer.wait_time = 2
	newTimer.one_shot = true;
	newTimer.connect("timeout", returnToNormal)
	newTimer.start();
	
func returnToNormal() -> void:
	self.get_node(cardname).queue_free()
	timeText.visible = false
	timeText.z_index = 2
	time.visible = false
	time.z_index = 2
	countdownTime = countTime
	if(cardpool.size() > 0):
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect, "modulate:a", 0, 0.3)
		shader_material.set_shader_parameter("opacity", 0.0)
		timer.start();
	elif(cardpool.size() == 0):
		displayText.visible = false
		endScreen()
	
func _on_timer_timeout() -> void:
	countdownTime -= 1
	displayText.text = str(countdownTime)
	if(countdownTime <= 0):
		if(cardpool.size() > 0):
			cardname = pickRandomCard()
			removeCardFromPool(cardname)
			stopwatch.reset()
			stopwatch.stopped = false
			displayText.text = cardname
		timer.stop()
	else:
		timer.start()

func pauseTime() -> void:
	stopwatch.stopped = true
	time.text = stopwatch.time_to_string()
	cardTime.append(stopwatch.time_to_string().replace("s", ""))
	
func returnCards() -> void:
	var cards = get_tree().get_nodes_in_group("inPlay")
	var cardslot = get_tree().get_nodes_in_group("card_slot")
	for card in cards:
		playerHand.add_card_to_hand(card)
		card.checking = false
		card.isInSlot = false
		card.remove_from_group("inPlay")
		card.add_to_group("draggable")
	for slot in cardslot:
		slot.add_to_group("card_slot_empty")
	

func endScreen() -> void:
	var totalTime= 0
	for time in cardTime:
		totalTime += time.to_float()
		
	var averageTimeSecond = totalTime / cardTime.size()
	var sigAverageTime = String("%.2f" % averageTimeSecond)
	averageTime.text = "Average Time: " + sigAverageTime + " s"

	averageTime.visible = true
	averageTime.z_index = 2
	averageTime.position.x = (get_viewport().get_visible_rect().size.x - averageTime.size.x) / 2
	averageTime.position.y = (4* (get_viewport().get_visible_rect().size.y - averageTime.size.y)) / 5
	shader_material.set_shader_parameter("opacity", 1.0)
	endText.visible = true
	endText.z_index = 2
	endText.position.x = (get_viewport().get_visible_rect().size.x - endText.size.x) / 2
	endText.position.y = (get_viewport().get_visible_rect().size.y - endText.size.y) / 2
	
