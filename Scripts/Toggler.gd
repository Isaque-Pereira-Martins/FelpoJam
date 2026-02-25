class_name Toggler extends Node2D

@export var jogador : TextureRect
@export var inimigo : TextureRect

func _ready() -> void:
	set_turno(2)

func set_turno(turno: int) -> void:
	var tween1 = create_tween()
	var tween2 = create_tween()
	if turno == 1:
		tween1.tween_property(jogador, "scale", Vector2(1.2,1.2), 0.2).set_trans(Tween.TRANS_QUAD)
		tween2.tween_property(inimigo, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
		jogador.material.set_shader_parameter("have_effect", 1.0)
		inimigo.material.set_shader_parameter("have_effect", 0)
		jogador.self_modulate = Color.LIME_GREEN
		inimigo.self_modulate = Color.DARK_RED
	else:
		tween1.tween_property(inimigo, "scale", Vector2(1.2,1.2), 0.2).set_trans(Tween.TRANS_QUAD)
		tween2.tween_property(jogador, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
		inimigo.material.set_shader_parameter("have_effect", 1.0)
		jogador.material.set_shader_parameter("have_effect", 0)
		inimigo.self_modulate = Color.LIME_GREEN
		jogador.self_modulate = Color.DARK_RED
