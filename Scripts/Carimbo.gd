class_name Carimbo extends Node2D

@export var button : Button
@export var sprite : Sprite2D
@export var atributo : Node = null
var display : DisplayCarimbo
var is_selected : bool = false
var walking : bool = false

func _ready() -> void:
	button.button_up.connect(button_clicked)
	
func button_clicked() -> void:
	if display.request_carimbo(self):
		var card = Globals.Selected_Card
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.5,1.5),0.2).set_trans(Tween.TRANS_QUAD)
		await tween.finished
		display.popOut()
		scale = Vector2(1,1)
		card.set_carimbo(self)
	else:
		if walking: return
		walking = true
		var actual_position = position
		var tween = create_tween()
		tween.tween_property(self, "position", actual_position + Vector2.RIGHT*15, 0.2).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", actual_position + Vector2.LEFT*15, 0.4).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", actual_position, 0.2).set_trans(Tween.TRANS_QUAD)
		await tween.finished
		walking = false
