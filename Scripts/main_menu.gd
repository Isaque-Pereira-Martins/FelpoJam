extends Control

@export var MusicaFundoPlayer : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaFundoPlayer.play_music_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	Globals.Change_scene_to("res://Scenes/battle.tscn")
	pass


func _on_options_pressed() -> void:
	Globals.Change_scene_to("res://Scenes/options_menu.tscn")
	pass


func _on_sair_pressed() -> void:
	get_tree().quit()
