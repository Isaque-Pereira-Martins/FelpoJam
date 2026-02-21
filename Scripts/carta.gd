class_name Carta extends Node2D

@export var atributos : AtributosCarta
@export var button : Button
@export_enum("InHand", "InLine") var state
var walking: bool = false#serve para não dar problema caso o player clique em dois holders rapidamente.
var actual_holder : Holder = null
var holder_scale : Vector2 = Vector2(1,1)
var player : Player = null
var enemie : Player = null

signal go_finished
signal atack_finished

func _ready() -> void:
	Globals.Selected_card_changed.connect(selected_changed)

func go_to_holder(holder: Holder) -> void:
	var holder_marker = holder.marker
	holder.link_card(self)
	actual_holder = holder
	holder_scale = actual_holder.marker.global_scale
	go_to(holder_marker.global_position, holder_marker.global_rotation,holder_marker.global_scale)
	go_finished.emit()
	
	#Atualizar estado de acordo com o holder que ele vai
	
	if holder.holder_tipe == "HandHolder":
		state = "InHand"
	elif holder.holder_tipe == "LineHolder":
		state = "InLine"

func go_to(pos: Vector2, rotat: float = global_rotation, scl: Vector2 = actual_holder.marker.global_scale) -> void:
	walking = true
	var tween1 = create_tween()
	tween1.tween_property(self, "global_position", pos,0.3).set_trans(Tween.TRANS_QUAD)
	var tween2 = create_tween()
	tween2.tween_property(self, "global_rotation", global_rotation + angle_difference(global_rotation,rotat),0.3).set_trans(Tween.TRANS_QUAD)
#	O angle_difference é necessário para ele percorrer o caminho mais curto até o angulo desejado
	var tween3 = create_tween()
	tween3.tween_property(self, "global_scale", scl,0.3).set_trans(Tween.TRANS_QUAD)
	await tween1.finished
	walking = false
	go_finished.emit()

func _on_button_button_up() -> void:
	if Globals.Selected_Card == self:
		return
	Globals.Select_card(self)
	z_index = 2
	#animação selecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.3,1.3),0.2).set_trans(Tween.TRANS_QUAD)
	
func selected_changed(card) -> void:
	if card == self:
		return
	z_index = 1
	#animação desselecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", holder_scale,0.2).set_trans(Tween.TRANS_QUAD)

func neg_request() -> void: #animação chamada quando o jogador não consegue colocar a carta
	Globals.Select_card(null)
	if walking:
		return
	walking = true
	var actual_position = position
	var tween = create_tween()
	tween.tween_property(self, "position", actual_position+Vector2(10,0),0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", actual_position-Vector2(10,0),0.4).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", actual_position,0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	walking = false

func atack() -> void:
	z_index = 2
	var holder_target : Holder = enemie.line.holders[enemie.line.size_cards-1-player.line.cards.find(self)]
	go_to(holder_target.marker.global_position + Vector2.UP.rotated(holder_target.global_rotation)*30)
	await self.go_finished
	go_to_holder(actual_holder)
	await self.go_finished
	z_index = 1
	atack_finished.emit()
