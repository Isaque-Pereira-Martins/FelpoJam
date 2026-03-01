class_name Carta extends Node2D

#region variaveis
@export var atributos : AtributosCarta
@export var life : SistemaVida
@export var button : Button
@export var selo_sprite : Sprite2D
@export var ataque_texto : Label
@export var vida_texto : Label
@export var carimbada_sprite : Sprite2D
@export var sword_sprite : Sprite2D
@export var brilho : AnimatedSprite2D
@export var texturas : Array[CompressedTexture2D]
@export var sprite : Sprite2D
@export_enum("InHand", "InLine") var state
var walking: bool = false#serve para não dar problema caso o player clique em dois holders rapidamente.
var actual_holder : Holder = null
var holder_scale : Vector2 = Vector2(1,1)
var player : Player = null
var enemie : Player = null
var selo : Selo = null
var ataque_bonus : int = 0
var brilho_colors : Dictionary = {"Alegria" : Color.YELLOW, "Paixão" : Color.HOT_PINK, "Raiva" : Color.RED, "Neutro" : Color(0,0,0,0)}
var holder_target : Holder = null
var card_target : Carta = null
#endregion

#region sinais
signal go_finished
signal atack_finished
signal feitico_finished
signal s_died(card: Carta)
signal sword_finished
#endregion

#region funções
func _ready() -> void:
	sprite.texture = texturas[0]
	brilho.modulate = brilho_colors[atributos.emocao]
	life.health_changed.connect(life_changed)
	life.died.connect(died)
	life.max_health = atributos.vida
	life.set_life(atributos.vida)

func buff() -> void:
	ataque_bonus = 2
	life.set_bonus(2)

func debuff() -> void:
	ataque_bonus = 0
	
	life.set_bonus(0)

func sword() -> void:
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.tween_property(sword_sprite,"self_modulate", Color.WHITE, 0.8).set_trans(Tween.TRANS_QUAD)
	tween1.tween_property(sword_sprite,"self_modulate", Color(0,0,0,0), 0.8).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(sword_sprite,"global_position", global_position + Vector2(0,-70), 0.4).set_trans(Tween.TRANS_QUAD)
	await tween1.finished
	sword_sprite.global_position += Vector2(0,70)
	sword_finished.emit()

func feitico() -> void:
	if atributos.classe == "Guerreiro":
		sword()
		await sword_finished
		var card = enemie.line.cards[enemie.line.size_cards-1-player.line.cards.find(self)]
		if card == null:
			enemie.sistemaVida.take_damage(25)
		else:
			card.hit(25)
		
	else:
		for card in player.line.cards:
			if card != self and card != null:
				card.atributos.ataque += 4
				card.life.max_health += 4
				card.life.heal(4)
				var tween = create_tween()
				tween.tween_property(card, "modulate", Color.YELLOW, 0.3).set_trans(Tween.TRANS_QUAD)
				tween.tween_property(card, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_QUAD)
				await tween.finished
				
				
	var timer = Timer.new()#O timer é necessario para caso a carta seja a unica na line, não ficar travado no await feitico_finished
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	feitico_finished.emit()

func carimbada() -> void:
	carimbada_sprite.show()
	var tween1 = create_tween()
	tween1.tween_property(carimbada_sprite, "scale", Vector2(1,1), 0.3).set_trans(Tween.TRANS_QUAD)
	var tween2 = create_tween()
	tween2.tween_property(carimbada_sprite, "rotation_degrees", 12.8, 0.3).set_trans(Tween.TRANS_QUAD)
	await tween2.finished
	
	if selo != null:
		selo.atributo.on_carimbada(self)
		await selo.atributo.efc_carimbada_fnsd
	
	feitico()
	await feitico_finished
	player.line.cards[player.line.cards.find(self)] = null
	player.update_emotions(atributos.emocao)
	actual_holder.unlink()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5,1.5),0.3).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2.ZERO,0.5).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	queue_free()
	

func go_to_holder(holder: Holder) -> void: #faz a carta ir até um holder, linka com ele, muda o estado da carta
	var holder_marker = holder.marker
	actual_holder = holder
	actual_holder.actual_card  = self
	holder_scale = actual_holder.marker.global_scale
	go_to(holder_marker.global_position, holder_marker.global_rotation,holder_marker.global_scale)
	
	#Atualizar estado de acordo com o holder que ele vai
	
	if holder.holder_tipe == "HandHolder":
		state = "InHand"
	elif holder.holder_tipe == "LineHolder":
		state = "InLine"

func go_to(pos: Vector2, rotat: float = global_rotation, scl: Vector2 = actual_holder.marker.global_scale) -> void: #animação da carta indo até um lugar
	walking = true
	var tween1 = create_tween()
	tween1.tween_property(self, "global_position", pos,0.3).set_trans(Tween.TRANS_QUAD)
	var tween2 = create_tween()
	tween2.tween_property(self, "global_rotation", global_rotation + angle_difference(global_rotation,rotat),0.3).set_trans(Tween.TRANS_QUAD)
#	O angle_difference é necessário para ele percorrer o caminho mais curto até o angulo desejado
	var tween3 = create_tween()
	tween3.tween_property(self, "global_scale", scl,0.3).set_trans(Tween.TRANS_QUAD)
	await tween1.finished
	walking = false
	go_finished.emit()

func _on_button_button_up() -> void: #muda o selected card no globals e muda a escala pra ficar maior
	if Globals.Selected_Card == self:
		return
	Globals.selo_select.emit(actual_holder)
	sprite.texture = texturas[1]
	Globals.Select_card(self)
	z_index = 2
	#animação selecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", holder_scale + Vector2(0.3,0.3),0.2).set_trans(Tween.TRANS_QUAD)
	
func selected_changed(card) -> void: #volta a escala da carta para o normal quando desselecionada
	if card == self:
		return
	sprite.texture = texturas[0]
	z_index = 1
	#animação desselecionar
	var tween = create_tween()
	tween.tween_property(self,"scale", holder_scale,0.2).set_trans(Tween.TRANS_QUAD)

func update_atributos() -> void:#muda os textos dos atributos da carta para valores atuais
	vida_texto.text = str(life.total_health)
	ataque_texto.text = str(atributos.ataque + ataque_bonus)

func life_changed(_max_life: int, current: int) -> void: #reage quando a vida muda chamando o update_atributos(por enquanto)
	atributos.vida = current
	update_atributos()

func neg_request() -> void: #animação quando não pode ser colocada em line
	Globals.Select_card(null)
	if walking:
		return
	walking = true
	var actual_position = position
	var tween = create_tween()
	tween.tween_property(self, "position", actual_position+Vector2(10,0),0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", actual_position-Vector2(10,0),0.4).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", actual_position,0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	walking = false

func atack() -> void: #ataca a carta a frente dela ou o jogador
	
	var index_target: int = enemie.line.size_cards-1-player.line.cards.find(self)
	holder_target = enemie.line.holders[index_target]
	card_target = enemie.line.cards[index_target]
	if selo != null:
		selo.atributo.on_attack(self)
		await selo.atributo.efc_attack_fnsd
	z_index = 3
	go_to(holder_target.marker.global_position + Vector2.UP.rotated(holder_target.global_rotation)*30)
	await self.go_finished
	if card_target == null:
		enemie.sistemaVida.take_damage(atributos.ataque + ataque_bonus)
	else:
		card_target.hit(atributos.ataque + ataque_bonus)
	go_to_holder(actual_holder)
	await self.go_finished
	z_index = 1
	atack_finished.emit()

func hit(amount: int) -> void: #muda a vida de acordo com o dano, animação de dano
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.ORANGE_RED,0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color.WHITE,0.2).set_trans(Tween.TRANS_QUAD)
	life.take_damage(amount)

func died() -> void:# Dá dinheiro ao outro jogador, disconecta do holder, animação morte, queue free
	s_died.emit(self)
	enemie.sistemaDinheiro.add_money(1)
	actual_holder.unlink()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2.ZERO,0.5).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	queue_free()

func set_selo(d_selo: Selo) -> void:#adiciona textura selo, animação selo colocado
	if selo != null:
		return
	selo = d_selo
	selo.atributo.auto(self)
	selo_sprite.texture = d_selo.sprite.texture
	selo_sprite.modulate = Color.YELLOW
	var tween = create_tween()
	tween.tween_property(selo_sprite,"modulate",Color.WHITE,0.5).set_trans(Tween.TRANS_QUAD)
#endregion
