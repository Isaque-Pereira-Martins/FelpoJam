extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaFundoPlayer.play_music_level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()
