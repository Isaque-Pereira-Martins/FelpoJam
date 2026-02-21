class_name Player extends Node

@export var line : CardLine
@export var hand : Hand
@export var deck : Deck
@export var sistemaDinheiro : SistemaDinheiro
#@export var sistemaVida : SistemaVida
@export var moneyLabel : Label = null
@export var enemie : Player = null

func _ready() -> void:
	deck.player = self
	deck.enemie = enemie
	line.player = self
	sistemaDinheiro.money_changed.connect(update_money)
	update_money(sistemaDinheiro.current_money)

func can_place_card(card: Carta) -> bool:
	if card.atributos.custo > sistemaDinheiro.current_money:
		return false
	return true

func update_money(current: int) -> void:
	if not moneyLabel:
		return
	moneyLabel.text = str(current)
