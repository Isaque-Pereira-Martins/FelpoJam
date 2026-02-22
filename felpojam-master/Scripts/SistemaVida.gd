class_name SistemaVida extends Node

#Variaveis
@export var max_health := 15
var current_health := 0

#Sinais
signal died
signal health_changed(max, current)

#Funções
func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	if current_health == 0:
		died.emit()
	health_changed.emit(max_health,current_health)
	
func heal(amount: int) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(max_health,current_health)
	
func set_life(amount: int) -> void:
	current_health = clamp(amount, 0, max_health)
	if current_health == 0:
		died.emit()
	health_changed.emit(max_health,current_health)
	
