class_name WinDisplay extends Node2D

signal to_menu
signal to_continue

@export var continue_button : TextureButton
@export var menu_button : TextureButton

func _ready() -> void:
	continue_button.button_up.connect(continue_pressed)
	menu_button.button_up.connect(menu_pressed)

func popOut() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	hide()

func popIn() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)

func continue_pressed() ->void:
	popOut()
	to_continue.emit()

func menu_pressed() -> void:
	popOut()
	to_menu.emit()
