extends Node

var cardpool = []
var displayText: Label
var timer: Timer
var countdownTime: int = 0
var cardname
var start = false;
var color_rect: ColorRect
var shader_material: ShaderMaterial
var shader_active: bool = false

func _ready() -> void:
	color_rect = $"../ColorRect"
	color_rect.size = get_viewport().get_visible_rect().size
	color_rect.z_index = 1
	shader_material = color_rect.material
	color_rect.modulate.a = 0
	shader_material.set_shader_parameter("opacity", 0.0)
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
	tween.tween_property(color_rect, "modulate:a", 1, 0.3)
	shader_material.set_shader_parameter("opacity", 1.0)
	color_rect.modulate.a = 255
	timer.connect("timeout", returnToNormal)
	timer.start();
	timer.one_shot = true;
	
func returnToNormal() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, 0.3)
	shader_material.set_shader_parameter("opacity", 0.0)
	
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
