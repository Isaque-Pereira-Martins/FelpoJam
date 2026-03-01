class_name atributo2 extends Node

signal efc_carimbada_fnsd
signal efc_attack_fnsd

func auto(_carta: Carta) -> void:
	pass

func on_attack(_card: Carta) -> void:
	var timer = Timer.new()
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	efc_attack_fnsd.emit()

func on_carimbada(card: Carta) -> void:
	card.feitico()
	await card.feitico_finished
	efc_carimbada_fnsd.emit()
