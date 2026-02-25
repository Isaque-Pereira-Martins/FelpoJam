class_name DisplayCarimbo extends Node2D

@export var carimbo1 : Carimbo
@export var carimbo2 : Carimbo
@export var label1 :Label
@export var label2 : Label
var quantidades : Dictionary

func _ready() -> void:
	quantidades[carimbo1] =  2
	quantidades[carimbo2] = 0
	update_label()
	carimbo1.display = self
	carimbo2.display = self
func popIn() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
	
func popOut() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale",Vector2.ZERO,0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	hide()
	
func request_carimbo(carimbo: Carimbo) -> bool:
	if quantidades[carimbo] > 0 and Globals.Selected_Card.carimbo == null:
		quantidades[carimbo] -= 1
		update_label()
		return true
	return false

func update_label() -> void:
	label1.text = str(quantidades[carimbo1])
	label2.text = str(quantidades[carimbo2])
