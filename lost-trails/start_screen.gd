extends Control


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/GameScenes/foxViewHomeDen.tscn")
	elif event is InputEventScreenTouch and event.pressed:
		get_tree().change_scene_to_file("res://scenes/GameScenes/foxViewHomeDen.tscn")
