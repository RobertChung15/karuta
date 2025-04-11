extends Node2D

var hasCard = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("card_slot_empty")

func fillCardSlot():
	add_to_group("card_slot")
	remove_from_group("card_slot_empty")
