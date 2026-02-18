class_name Carta extends Node2D

@export var atributos : AtributosCarta
@export var button : Button
var walking: bool = false#serve para não dar problema caso o player clique em dois holders rapidamente.
var holder_scale: Vector2 = Vector2(1,1)# para a carta não voltar ao scale (1,1) ao ser desselecionada

signal go_finished(holder: Holder)

func _ready() -> void:
	Globals.Selected_card_changed.connect(selected_changed)

func go_to(holder: Holder) -> void:
	
	walking = true
	holder.link_card(self)
	holder_scale = holder.marker.global_scale
	var tween1 = create_tween()
	tween1.tween_property(self, "global_position", holder.marker.global_position,0.3).set_trans(Tween.TRANS_QUAD)
	var tween2 = create_tween()
	tween2.tween_property(self, "rotation_degrees", holder.marker.global_rotation_degrees,0.3).set_trans(Tween.TRANS_QUAD)
	var tween3 = create_tween()
	tween3.tween_property(self, "scale", holder.marker.global_scale,0.3).set_trans(Tween.TRANS_QUAD)
	await tween1.finished
	walking = false
	go_finished.emit(holder)


func _on_button_button_up() -> void:
	if Globals.Selected_Card == self:
		return
	Globals.Select_card(self)
	#animação selecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.3,1.3),0.2).set_trans(Tween.TRANS_QUAD)
	
func selected_changed(card) -> void:
	if card == self:
		return
	#animação desselecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", holder_scale,0.2).set_trans(Tween.TRANS_QUAD)
