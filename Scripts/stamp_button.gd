class_name StampButton extends Node2D

@export var sprite : Sprite2D
@export var button : Button

signal pressed

func _ready() -> void:
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)

func exit() -> void:
	sprite.scale = Vector2.ZERO
	hide()

func popIn() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)

func _on_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.8,0.8), 0.1)

func _on_button_up() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.1)
	await tween.finished
	pressed.emit()
	exit()
