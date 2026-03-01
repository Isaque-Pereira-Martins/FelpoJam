class_name atributo3 extends Node

signal efc_carimbada_fnsd
signal efc_attack_fnsd

func auto(_card: Carta) -> void:
	pass

func on_attack(card: Carta) -> void:
	var a = true
	while a:
		var holder : Holder= await Globals.selo_select
		if holder.holder_tipe == "LineHolder" and holder.player == card.enemie:
			card.card_target = holder.actual_card
			card.holder_target = holder
			a = false
	Globals.Select_card(null)
	efc_attack_fnsd.emit()

func on_carimbada(_card: Carta) -> void:
	var timer = Timer.new()
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	efc_carimbada_fnsd.emit()
