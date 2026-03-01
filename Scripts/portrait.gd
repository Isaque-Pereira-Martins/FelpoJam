class_name Portrait extends Node2D
@export var background : Sprite2D
@export var picture : Sprite2D
@export var heart : Heart
@export var moldura_textura : CompressedTexture2D

func _ready() -> void:
	background.texture = moldura_textura
