class_name atributo1 extends Node

signal efc_carimbada_fnsd
signal efc_attack_fnsd

func auto(card: Carta) -> void:
	card.atributos.ataque *= 2
	card.life.max_health *= 2 
	card.life.set_life(card.life.max_health)
	card.update_atributos()
	
func on_attack(_card: Carta) -> void:
	var timer = Timer.new()
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	efc_attack_fnsd.emit()

func on_carimbada(_card: Carta) -> void:
	var timer = Timer.new()
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	efc_carimbada_fnsd.emit()
