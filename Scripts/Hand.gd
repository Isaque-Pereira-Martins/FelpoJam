class_name Hand extends Node2D

var size_cards : int = 0
var cards : Array[Carta] = []
var holders : Array[Holder] = []
var holderPL = preload("res://Scenes/cards_holder.tscn")
		
func calculate(alc,maximum,index, absolute: bool = false) -> float:# serve para calcular um valor de uma posição em um range igualmente espaçado
	# o absolute serve para dizer se a curva de valores forma um V ou uma linha reta /
	if maximum == 1:
		return 0
	var pos = alc/(maximum-1)*index - alc/2	
	if absolute:
		return abs(pos)
	return pos

func calculate_holder(holder: Holder, index) -> void: # um monte de calculate juntos para diversas propriedades
	holder.position.x = calculate(clamp(size_cards*50,0,200),size_cards,index)
	holder.position.y = calculate(30,size_cards,index, true)
	holder.rotation_degrees = calculate(20,size_cards,index)
	holder.scale = Vector2(0.8,0.8)

func delete_holder(holder: Holder) -> void:
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
	#holderInstance.modulate = Color(0.0, 0.0, 0.0, 0.0)
	add_child(holderInstance)
	holders.append(holderInstance)
	update_holders()

func new_card(card: Carta) -> void:
	create_holder()
	card.go_to(holders[-1])
