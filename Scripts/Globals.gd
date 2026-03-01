extends Node

var Selected_Card : Carta = null
var carimbos : Array[int] = [1,1,1]

signal Selected_card_changed(card: Carta)
signal selo_select(holder: Holder)

func Select_card(card: Carta) -> void:
	var old_card : Carta = Selected_Card
	Selected_Card = card
	if old_card != null:
		old_card.selected_changed(Selected_Card)
	Selected_card_changed.emit(card)

#Coloquei essa função no Globals pois ela é muito utilizada por diversos scritps
func calculate(alc,maximum,index, absolute: bool = false) -> float:# serve para calcular um valor de uma posição em um range igualmente espaçado
	# o absolute serve para dizer se a curva de valores forma um V ou uma linha reta /
	if maximum == 1:
		return 0
	var pos = alc/(maximum-1)*index - alc/2	
	if absolute:
		return abs(pos)
	return pos
	
func Change_scene_to(path: String) -> void:
	var scene = load(path)
	var sceneInstance = scene.instantiate()
	get_tree().current_scene.add_child(sceneInstance)
	get_tree().current_scene.get_child(0).call_deferred("queue_free")

func melhor_carta(player: Player) -> Carta:
	var cards = player.hand.cards
	var best_card : Carta = null
	var soma = 0
	for carta in cards:
		if carta != null:
			if carta.atributos.ataque + carta.atributos.vida > soma:
				best_card = carta
				soma = carta.atributos.ataque + carta.atributos.vida
	return best_card
	
func melhor_holder(player: Player, contra: Player) -> Holder:
	var holders = player.line.holders
	var null_holder : Holder = null
	var best_holder : Holder = null
	var pior_vida = 1000
	for holder in holders:
		var index = player.line.size_cards-1-holders.find(holder)
		var carta_inimiga = contra.line.cards[index]
		if holder.actual_card == null:
			null_holder = holder
			if carta_inimiga != null and carta_inimiga.atributos.vida < pior_vida:
				best_holder = holder
				pior_vida = carta_inimiga.atributos.vida
	if best_holder == null and null_holder != null:
		best_holder = null_holder
	return best_holder
