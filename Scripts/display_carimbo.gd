class_name DisplayCarimbo extends Node2D

@export var selo1 : Selo
@export var selo2 : Selo
@export var selo3 : Selo
@export var label1 :Label
@export var label2 : Label
@export var label3 : Label
var quantidades : Dictionary

func _ready() -> void:
	quantidades[selo1] =  2
	quantidades[selo2] = 2
	quantidades[selo3] = 2
	update_label()
	selo1.display = self
	selo2.display = self
	selo3.display = self

func update_selos(quantidade : Array) -> void:
	quantidades[selo1] = quantidade[0]
	quantidades[selo2] = quantidade[1]
	quantidades[selo3] = quantidade[2]
	update_label()
	
func popIn() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
	
func popOut() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale",Vector2.ZERO,0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	hide()
	
func request_selo(selo: Selo) -> bool:
	if quantidades[selo] > 0 and Globals.Selected_Card.selo == null:
		quantidades[selo] -= 1
		if selo == selo1:
			Globals.carimbos[0] -= 1
		elif selo == selo2:
			Globals.carimbos[1] -= 1
		elif selo == selo3:
			Globals.carimbos[2] -= 1
		update_label()
		return true
	return false

func update_label() -> void:
	label1.text = str(quantidades[selo1])
	label2.text = str(quantidades[selo2])
	label3.text = str(quantidades[selo2])
