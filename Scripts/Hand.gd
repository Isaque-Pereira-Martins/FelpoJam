extends Node


@export var cards: Array = []

signal card_exit(card)
signal cards_changed(array)

func new_card(card) -> void:
	cards.append(card)
	cards_changed.emit(cards)
	
func play_card(card) -> void:
	card_exit.emit(card)
	cards.erase(card)
	cards_changed.emit(cards)
