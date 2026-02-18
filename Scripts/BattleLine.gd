extends Node


@export var size := 4
var line_cards: Array = []

func _ready() -> void:
	for i in range(size):
		line_cards.append(null)

func display_card(card, index) -> void:
	line_cards[index] = card
	
func change_card(index, card = null):
	var ret = line_cards[index]
	line_cards[index] = card
	return ret
