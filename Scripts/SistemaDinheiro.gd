class_name SistemaDinheiro extends Node

#Variaveis
@export var current_money := 10

#Sinais
signal money_changed(current)
signal not_enoght_money()

#Funções
func add_money(amount: int) -> void:
	current_money += amount
	money_changed.emit(current_money)
	
func subtract_money(amount: int) -> bool:
	if amount > current_money:
		not_enoght_money.emit()
		return false
	current_money -= amount
	money_changed.emit(current_money)
	return true
	
func set_money(amount: int) -> void:
	if amount < 0:
		current_money = 0
		return
	current_money = amount
	money_changed.emit(current_money)
