extends Node2D
var peer = ENetMultiplayerPeer.new()
const PORT = 4040 
const SERVER_ADDRESS = "localhost"

@export var playerScene: PackedScene
@export var opponentScene: PackedScene
@export var singlePlayerScene: PackedScene
@onready var timer = $Timer
@onready var cardManager = $CardManager

func _on_host_button_pressed() -> void:
	disable_buttons()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	var pScene = playerScene.instantiate()
	add_child(pScene)

func disable_buttons() -> void:
	$HostButton.disabled = true
	$HostButton.visible = false
	$JoinButton.disabled = true
	$JoinButton.visible = false
	$SinglePlayer.disabled = true
	$SinglePlayer.visible = false
	
func _on_join_button_pressed() -> void:
	disable_buttons()
	peer.create_client(SERVER_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	var pScene = playerScene.instantiate()
	add_child(pScene)
	var oScene = opponentScene.instantiate()
	add_child(oScene)
	#cardManager.client_set_up()
	
func _on_peer_connected(_peer_id) -> void:
	var oScene = opponentScene.instantiate()
	add_child(oScene)
	timer.start()
	#get_node("CardManager").host_set_up()
	
func _on_single_player_pressed() -> void:
	disable_buttons()
	var singlePlayerScene = singlePlayerScene.instantiate()
	add_child(singlePlayerScene)
	
func _on_timer_timeout() -> void:
	cardManager.startGame()
	pass # Replace with function body.
