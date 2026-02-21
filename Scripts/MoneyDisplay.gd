class_name MoneyDisplay extends Node2D

@export var size :int = 5
var coinPL = preload("res://Scenes/coin.tscn")
var coins :Array[Node2D] = []

signal move_finished

func _ready() -> void:
	for i in range(size):
		create_coin(i)
	display_coins(0)
		
func create_coin(index: int) -> void:
	var coinInstance : Node2D = coinPL.instantiate()
	coinInstance.position.x = Globals.calculate(120, size, index)
	coinInstance.position.y = 100
	coins.append(coinInstance)
	add_child(coinInstance)

func display_coins(value: int) -> void:
	value = clamp(value, 0,size)
	for i in range(value):
		move_coin(coins[i], 0)
		await self.move_finished
	for i in range(size-value):
		
		move_coin(coins[-i-1],100)
		await self.move_finished

func move_coin(coin: Node2D, pos: float) -> void:
	var tween = create_tween()
	tween.tween_property(coin, "position", Vector2(coin.position.x, pos), 0.05).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	move_finished.emit()
