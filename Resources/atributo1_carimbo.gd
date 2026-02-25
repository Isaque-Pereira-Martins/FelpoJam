class_name atributo1 extends Node

func auto(card: Carta) -> void:
	card.atributos.ataque *= 2
	card.life.max_health *= 2 
	card.life.set_life(card.life.max_health)
	card.update_atributos()
	
func on_attack(_card: Carta) -> void:
	pass

func on_died(_card: Carta) -> void:
	pass
