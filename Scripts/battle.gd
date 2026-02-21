extends Node2D

@export var coins_display : MoneyDisplay
@export var jogador : Player
@export var inimigo : Player
@export var painel : PainelAtributos
var player_round : Player

func _ready() -> void:
	player_round = jogador
	Globals.Selected_card_changed.connect(card_selected)

func card_selected(card: Carta) -> void:
	#display o custo
	if card == null:
		coins_display.display_coins(0)
	elif card.player == jogador and card.state == "InHand":
		coins_display.display_coins(card.atributos.custo)
	else:
		coins_display.display_coins(0)
		
	#display painel de atributos
	
	if card == null:
		painel.pop_out()
		await painel.out
		painel.visible = false
	else:
		painel.visible = true
		painel.set_text(card)
		painel.pop_in()

func end_round(Player_round: Player) -> void:
	Globals.Select_card(null)
	for card : Carta in Player_round.line.cards:
		if card != null:
			card.atack()
			await card.atack_finished
	#trocar rounds
	if Player_round == jogador:
		player_round = inimigo
	if Player_round == inimigo:
		player_round = jogador

func _on_end_round_button_up() -> void:
	end_round(player_round)
