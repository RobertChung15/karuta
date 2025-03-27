extends Node2D

var playerHand

func _ready() -> void:
	playerHand = $"../PlayerHand"
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if(Input.is_action_just_pressed("leftClick")):
			playerHand.startGame()
			$Area2D/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
