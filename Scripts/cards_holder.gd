class_name Holder extends Node2D

var actual_card : Carta = null
@export var marker : Marker2D
@export var button : Button
@export_enum("HandHolder", "LineHolder") var holder_tipe
var linked = false
var player: Player = null

signal card_out(holder: Holder)

func _on_button_button_up() -> void:
	var card = Globals.Selected_Card
	if card == null or actual_card != null or card.walking:
		#caso o jogador clique no holder sem carta selecionada ou holder já com carta ou com carta selecionada já em transição
		return
	if card.state == "InLine": #Não permite que uma carta que já esteja na arena troque de hoder
		Globals.Select_card(null)
		return
	set_card_request(Globals.Selected_Card)
	

func card_leaves() -> void:
	if actual_card.actual_holder == self:
		return
	unlink()
	card_out.emit(self)

func update_card() -> void:
	if actual_card == null:
		return
	actual_card.go_to_holder(self)

func unlink() -> void:
	actual_card.go_finished.disconnect(card_leaves)
	linked = false
	actual_card = null
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	
func link_card(card: Carta) -> void:
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if linked:
		return
	actual_card = card
	card.go_finished.connect(card_leaves)
	linked = true

func set_card_request(card: Carta) -> void:
	if card.player != player or not player.jogando:
		Globals.Select_card(null)
		return
	if not player.can_place_card(card):
		card.neg_request()
		return
	link_card(card)
	card.go_to_holder(self)
	Globals.Select_card(null)
	player.sistemaDinheiro.subtract_money(card.atributos.custo)
	player.line.add_cards(card,player.line.holders.find(self))
