class_name Deck extends Node2D

@export var hand : Hand
var cards : Array[Carta] = []
var cartaPL = preload("res://Scenes/carta.tscn")

func _ready() -> void:
	for i in range(6):
		var cartaInstance : Carta = cartaPL.instantiate()
		cartaInstance.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cards.append(cartaInstance)
		add_child(cartaInstance)

func drag() -> void:
	if cards.size() == 0:
		return
	cards[-1].button.mouse_filter = Control.MOUSE_FILTER_STOP
	hand.new_card(cards.pop_at(-1))

func _on_button_button_up() -> void:
	drag()
