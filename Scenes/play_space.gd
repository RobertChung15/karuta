extends Node2D
var shader_material: ShaderMaterial
var shader_active: bool = false

func _ready() -> void:
	shader_material = $ColorRect.material
	shader_material.set_shader_parameter("opacity", 0.0)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("exit")):
		get_tree().quit()
	elif(event.is_action_pressed("test")):
		shader_active = true
		shader_material.set_shader_parameter("opacity", 1.0)  # Set to fully opaque
