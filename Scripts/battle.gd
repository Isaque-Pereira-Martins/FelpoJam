extends Node2D

@onready var deck : Deck = $Deck

func _ready() -> void:
	for i in range(3):
		deck.drag()
	
