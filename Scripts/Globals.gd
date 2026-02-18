extends Node

var Selected_Card : Carta = null

signal Selected_card_changed(card)#enviado para as cartas verificarem se foram desselecionadas

func Select_card(card: Carta) -> void:
	Selected_Card = card
	Selected_card_changed.emit(card)
