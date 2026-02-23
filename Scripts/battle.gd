extends Node2D

@export var coins_display : MoneyDisplay
@export var jogador : Player
@export var inimigo : Player
@export var painel : PainelAtributos
@export var stop_mouse : Panel
@export var round_text : Label
@export var toggler : Toggler
var player_round : Player
var jogada : int = 0

func _ready() -> void:
	player_round = inimigo
	player_round.jogando = true
	jogador.deck.drag(3)
	inimigo.deck.drag(3)
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
	stop_mouse.show()
	Globals.Select_card(null)
	
	#Ataque de cartartas
	if jogada != 0:
		for card : Carta in Player_round.line.cards:
			if card != null:
				card.atack()
				await card.atack_finished
	#trocar rounds
	if Player_round == jogador:
		inimigo.jogando = true
		player_round = inimigo
		jogada += 1
		round_text.text = "Round " + str(jogada)
		toggler.set_turno(2)
	if Player_round == inimigo:
		jogador.jogando = true
		player_round = jogador
		toggler.set_turno(1)
	Player_round.jogando = false
	stop_mouse.hide()
	start_jogada()

func start_jogada() -> void:
	player_round.deck.drag(1)

func _on_end_round_button_up() -> void:
	end_round(player_round)
