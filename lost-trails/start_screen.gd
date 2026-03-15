extends Control

var _music: AudioStreamPlayer

func _ready() -> void:
	_music = AudioStreamPlayer.new()
	add_child(_music)
	var stream = load("res://assats/music/Fox's Theme.mp3")
	if stream:
		stream.loop = true
		_music.stream = stream
		_music.play()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/GameScenes/foxViewHomeDen.tscn")
	elif event is InputEventScreenTouch and event.pressed:
		get_tree().change_scene_to_file("res://scenes/GameScenes/foxViewHomeDen.tscn")
	elif event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://scenes/GameScenes/foxViewHomeDen.tscn")
