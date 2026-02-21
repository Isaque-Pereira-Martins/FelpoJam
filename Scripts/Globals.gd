extends Node

var Selected_Card : Carta = null

signal Selected_card_changed(card)#enviado para as cartas verificarem se foram desselecionadas

func Select_card(card: Carta) -> void:
	Selected_Card = card
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
