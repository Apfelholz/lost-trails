extends Control

@onready var start_button = $CenterContainer/Menu/StartButton


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
