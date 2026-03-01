class_name Hand extends Node2D

@export var is_player := true
var size_cards : int = 0
var cards : Array[Carta] = []
var holders : Array[Holder] = []
var holderPL = preload("res://Scenes/cards_holder.tscn")

func calculate_holder(holder: Holder, index) -> void: # um monte de calculate juntos para diversas propriedades
	holder.position.x = Globals.calculate(clamp(size_cards*50,0,200),size_cards,index)
	holder.position.y = Globals.calculate(30,size_cards,index, true)
	holder.rotation_degrees = Globals.calculate(20,size_cards,index)
	holder.scale = Vector2(1.2,1.2)

func delete_holder(holder: Holder) -> void:
	cards.pop_at(cards.find(holder.actual_card))
	size_cards -= 1
	holders.erase(holder)
	holder.queue_free()
	update_holders()

func update_holders() -> void:
	for i in range(size_cards):
		calculate_holder(holders[i], i)
		holders[i].update_card()

func create_holder() -> void:
	size_cards += 1
	var holderInstance: Holder = holderPL.instantiate()
	calculate_holder(holderInstance, size_cards-1)
	holderInstance.card_out.connect(delete_holder)
	holderInstance.modulate = Color(0.0, 0.0, 0.0, 0.0)
	holderInstance.holder_tipe = "HandHolder"
	holderInstance.is_player = is_player
	add_child(holderInstance)
	holders.append(holderInstance)
	update_holders()

func new_card(card: Carta) -> void:
	cards.append(card)
	create_holder()
	card.go_to_holder(holders[-1])
	holders[-1].link_card(card)
