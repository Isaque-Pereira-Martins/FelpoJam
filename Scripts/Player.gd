class_name Player extends Node

@export var line : CardLine
@export var hand : Hand
@export var deck : Deck
@export var sistemaDinheiro : SistemaDinheiro
@export var sistemaVida : SistemaVida
@export var moneyLabel : Label = null
@export var enemie : Player = null
@export var portrait : Portrait
var jogando : bool = false

signal died(player: Player)

func _ready() -> void:
	deck.player = self
	deck.enemie = enemie
	line.player = self
	sistemaDinheiro.money_changed.connect(update_money)
	update_money(sistemaDinheiro.current_money)
	sistemaVida.health_changed.connect(life_changed)
	sistemaVida.died.connect(f_died)

func update_emotions(emotion : String) -> void:
	var cards : Array[Carta] = []
	for card : Carta in line.cards:
		if card != null and card.atributos.emocao == emotion:
			cards.append(card)
	if cards.size() >= 2:
		for card in cards:
			card.buff()
			card.brilho.show()
	else:
		for card in cards:
			card.debuff()
			card.brilho.hide()
	

func f_died() -> void:
	died.emit(self)

func can_place_card(card: Carta) -> bool:
	if card.atributos.custo > sistemaDinheiro.current_money:
		return false
	return true

func update_money(current: int) -> void:
	if not moneyLabel:
		return
	moneyLabel.text = str(current)
	
func life_changed(max_life : int,life: int) -> void:
	portrait.heart.max_life = max_life
	portrait.heart.set_life(life)
