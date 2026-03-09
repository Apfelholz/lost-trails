extends Area2D

@export var layer_id: int = 0


func _ready():

	add_to_group("layer_boundary")

	monitoring = false