extends Control

const SCROLL_SPEED: float = 80.0

@onready var credits: Label = $CreditsContainer/Credits


func _ready() -> void:
	credits.position.y = get_viewport_rect().size.y


func _process(delta: float) -> void:
	credits.position.y -= SCROLL_SPEED * delta
	if credits.position.y + credits.size.y < 0:
		get_tree().change_scene_to_file("res://scenes/GameScenes/start_screen.tscn")


#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.pressed:
#		get_tree().change_scene_to_file("res://scenes/GameScenes/start_screen.tscn")
#	elif event is InputEventScreenTouch and event.pressed:
#		get_tree().change_scene_to_file("res://scenes/GameScenes/start_screen.tscn")
#	elif event is InputEventKey and event.pressed:
#		get_tree().change_scene_to_file("res://scenes/GameScenes/start_screen.tscn")
