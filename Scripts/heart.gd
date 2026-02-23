class_name Heart extends Node2D

@export var sprite : Sprite2D
@export var texture : Array[CompressedTexture2D]
@export var life_text : Label
@export var max_life : int = 20
var current_life : = 0

func set_life(life: int) -> void:
	if life == 0:
		sprite.texture = texture[0]
		life_text.text = ""
		return
	@warning_ignore("integer_division")
	var texture_index = int(life/max_life)*4
	sprite.texture = texture[texture_index]
	life_text.text = str(life)
