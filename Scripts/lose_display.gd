class_name LoseDisplay extends Node2D

@export var replay_button : TextureButton
@export var menu_button : TextureButton

signal to_menu
signal replay

func _ready() -> void:
	replay_button.button_up.connect(replay_pressed)
	menu_button.button_up.connect(menu_pressed)

func replay_pressed() -> void:
	popOut()
	replay.emit()

func menu_pressed() -> void:
	popOut()
	to_menu.emit()

func popIn() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
	
func popOut() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	hide()
