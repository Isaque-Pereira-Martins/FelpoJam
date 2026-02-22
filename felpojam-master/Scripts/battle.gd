extends Node2D

@onready var deck : Deck = $Deck

func _ready() -> void:
	for i in range(3):
		deck.drag()
		
	# n sei ainda como parar a musica
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
