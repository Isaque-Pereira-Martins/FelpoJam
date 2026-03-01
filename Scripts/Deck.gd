class_name Deck extends Node2D

#region variaveis
@export var hand : Hand
@export var Atributos :Array[AtributosCarta]
@export var texturas : Array[CompressedTexture2D]
@export var sprite : Sprite2D
var cards : Array[Carta] = []
var cartaPL = preload("res://Scenes/carta.tscn")
var player : Player = null
var enemie : Player = null
#endregion

#region funções
func _ready() -> void:
	sprite.texture = texturas[2]
	for atributo : AtributosCarta in Atributos:
		var cartaInstance : Carta = cartaPL.instantiate()
		cartaInstance.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cartaInstance.player = player
		cartaInstance.enemie = enemie
		cartaInstance.atributos = atributo
		cartaInstance.texturas = texturas
		cards.append(cartaInstance)
		add_child(cartaInstance)

func drag(quant: int) -> void:
	Globals.Select_card(null)
	if quant > cards.size():
		quant = cards.size()
	for i in range(quant):
		cards[-1].button.mouse_filter = Control.MOUSE_FILTER_STOP
		hand.new_card(cards.pop_at(-1))
#endregion
