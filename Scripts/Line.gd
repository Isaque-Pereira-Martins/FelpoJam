class_name CardLine extends Node2D

@export var size_cards := 4
@export var is_player := true
var holderPL = preload("res://Scenes/cards_holder.tscn")
var holders : Array[Holder] = []
var cards: Array[Carta] = []
var player: Player = null

func _ready() -> void:
	for i in range(size_cards):
		create_holder(i)
		cards.append(null)
		
func create_holder(index) -> void:
	var holderInstance : Holder = holderPL.instantiate()
	holderInstance.position.x = Globals.calculate(size_cards*50, size_cards,index)
	holderInstance.player = player
	holderInstance.holder_tipe = "LineHolder"
	holderInstance.is_player = is_player
	holderInstance.scale = Vector2(1.2,1.2)
	holders.append(holderInstance)
	add_child(holderInstance)

func add_cards(card: Carta, index: int) -> void:
	cards[index] = card
	card.s_died.connect(card_died)
	player.update_emotions(card.atributos.emocao)

func card_died(card: Carta) -> void:
	cards[cards.find(card)] = null
	player.update_emotions(card.atributos.emocao)
