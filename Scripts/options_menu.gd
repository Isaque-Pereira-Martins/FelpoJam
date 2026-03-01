extends Control

@export var MusicaFundoPlayer : AudioStreamPlayer
var master_bus_id
var musica_bus_id
var efeitos_bus_id
var screen_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_bus_id = AudioServer.get_bus_index("Master")
	musica_bus_id = AudioServer.get_bus_index("Musica")
	efeitos_bus_id = AudioServer.get_bus_index("Efeitos")
	MusicaFundoPlayer.play_music_level()
	
	$HBoxContainer/ScreenButton.selected = 2
	if DisplayServer.window_get_mode() == 0:
		$HBoxContainer/ScreenButton.selected = 0
	elif DisplayServer.window_get_mode() == 2:
		$HBoxContainer/ScreenButton.selected = 1
	elif DisplayServer.window_get_mode() == 3:
		$HBoxContainer/ScreenButton.selected = 2
	

func _on_voltar_pressed() -> void:
	Globals.Change_scene_to("res://Scenes/main_menu.tscn")
	pass


func _on_screen_button_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
