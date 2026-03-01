class_name SistemaVida extends Node

#Variaveis
@export var max_health := 15
var current_health := 0
var bonus_health := 0
var total_health := 0

#Sinais
signal died
signal health_changed(max, current)

#Funções
func _ready() -> void:
	current_health = max_health
	total_health = current_health + bonus_health

func take_damage(amount: int) -> void:
	total_health = clamp(total_health - amount, 0, max_health + bonus_health)
	current_health = clamp(current_health - amount, -10, max_health)
	if total_health == 0:
		died.emit()
	health_changed.emit(max_health,total_health)
	
func heal(amount: int) -> void:
	total_health = clamp(total_health + amount, 0, max_health + bonus_health)
	current_health = clamp(current_health + amount, -10, max_health)
	health_changed.emit(max_health,total_health)
	
func set_life(amount: int) -> void:
	total_health = clamp(amount, 0, max_health + bonus_health)
	current_health = clamp(amount, 0, max_health)
	if total_health == 0:
		died.emit()
	health_changed.emit(max_health,total_health)

func set_bonus(amount) -> void:
	bonus_health = amount
	total_health = clamp(current_health + bonus_health, 0, max_health + bonus_health)
	if total_health == 0:
		died.emit()
	health_changed.emit(max_health,total_health)
