class_name PainelAtributos extends Node2D

@export var classe : Label
@export var emocao : Label
@export var texto : Label

signal out

func set_text(card: Carta) -> void:
	classe.text = card.atributos.classe
	emocao.text = card.atributos.emocao
	texto.text = card.atributos.texto
	
func pop_in() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1,1),0.2).set_trans(Tween.TRANS_QUAD)

func pop_out() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	out.emit()
