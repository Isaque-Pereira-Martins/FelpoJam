class_name Holder extends Node2D

var actual_card : Carta = null
@export var marker : Marker2D
@export var button : Button
var linked = false

signal card_out(holder: Holder)

func _on_button_button_up() -> void:
	if Globals.Selected_Card == null or actual_card != null or Globals.Selected_Card.walking:
		#caso o jogador clique no holder sem carta selecionada ou holder já com carta ou com carta selecionada já em transição
		return
	Globals.Selected_Card.go_to(self)
	Globals.Select_card(null)

func card_leaves(holder: Holder) -> void:
	if holder == self:
		return
	actual_card.go_finished.disconnect(card_leaves)
	linked = false
	actual_card = null
	card_out.emit(self)

func update_card() -> void:
	if actual_card == null:
		return
	actual_card.go_to(self)
	
func link_card(card: Carta) -> void:
	if linked:
		return
	actual_card = card
	card.go_finished.connect(card_leaves)
	linked = true
