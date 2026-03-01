class_name Battle extends Node2D

@export var coins_display : MoneyDisplay
@export var jogador : Player
@export var inimigo : Player
@export var painel : PainelAtributos
@export var round_text : Label
@export var toggler : Toggler
@export var deselect : Button
@export var display_selos : DisplayCarimbo
@export var lose_display : LoseDisplay
@export var stamp_button : StampButton
@export var dia_label : Label
@export var win_dispay : WinDisplay
@export var menu_button : TextureButton
@export var atributos : BattleAtributos
@export var endround_button : Button
var player_round : Player
var jogada : int = 0
var inimigo_life = 80
var jogador_life = 200

func _ready() -> void:
	dia_label.text = "dia " + str(atributos.dia)
	display_selos.update_selos(Globals.carimbos)
	jogador.deck.Atributos = atributos.player_cartas
	inimigo.deck.Atributos = atributos.inimigo_cartas
	inimigo.portrait.picture.texture = atributos.inimigo_portrait
	jogador.portrait.heart.max_life = jogador_life
	jogador.sistemaVida.max_health = jogador_life
	jogador.sistemaVida.heal(jogador_life)
	inimigo.portrait.heart.max_life = inimigo_life
	inimigo.sistemaVida.max_health = inimigo_life
	inimigo.sistemaVida.heal(inimigo_life)
	player_round = inimigo
	player_round.jogando = true
	jogador.deck.drag(3)
	inimigo.deck.drag(3)
	Globals.Selected_card_changed.connect(card_selected)
	deselect.button_up.connect(deselect_pressed)
	inimigo.died.connect(player_died)
	jogador.died.connect(player_died)
	lose_display.to_menu.connect(to_menu)
	lose_display.replay.connect(replay)
	stamp_button.pressed.connect(stamped_pressed)
	win_dispay.to_menu.connect(to_menu)
	menu_button.button_up.connect(to_menu)
	endround_button.button_up.connect(_on_end_round_button_up)
	jogada_inimigo()
	

func stamped_pressed() -> void:
	if Globals.Selected_Card == null:
		return
	Globals.Selected_Card.carimbada()

func to_menu() -> void:
	Globals.Change_scene_to("res://Scenes/main_menu.tscn")
	get_tree().paused = false
	
func replay() -> void:
	Globals.Change_scene_to("res://Scenes/battle.tscn")
	get_tree().paused = false

func player_died(player: Player) -> void:
	if player == jogador:
		get_tree().paused = true
		lose_display.popIn()
	else:
		get_tree().paused = true
		win_dispay.popIn()
		

func card_selected(card: Carta) -> void:
	#display o custo
	if card == null:
		coins_display.display_coins(0)
	elif card.player == jogador and card.state == "InHand":
		coins_display.display_coins(card.atributos.custo)
	else:
		coins_display.display_coins(0)
		
	#display selos
	
	if card == null:
		display_selos.popOut()
	elif card.player == jogador and card.state == "InHand" and player_round == jogador:
		display_selos.popIn()
	else:
		display_selos.popOut()
	
	#display carimbo
	
	if card == null:
		stamp_button.exit()
	elif card.player == jogador and card.state == "InLine" and player_round == jogador:
		stamp_button.popIn()
	else:
		stamp_button.exit()
	
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
	Player_round.jogando = false
	endround_button.disabled = true
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
	endround_button.disabled = false
	start_jogada()

func start_jogada() -> void:
	player_round.sistemaDinheiro.add_money(1)
	player_round.deck.drag(1)
	if player_round == inimigo:
		jogada_inimigo()

func jogada_inimigo() -> void:
	for i in range(2):
		var timer = Timer.new()
		timer.wait_time = 1
		add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
		var carta : Carta = Globals.melhor_carta(inimigo)
		var holder : Holder = Globals.melhor_holder(inimigo, jogador)
		if carta != null and holder != null:
			holder.set_card_request(carta)
	end_round(player_round)

func deselect_pressed() -> void:
	Globals.Select_card(null)

func _on_end_round_button_up() -> void:
	if player_round == inimigo:
		return
	end_round(player_round)
