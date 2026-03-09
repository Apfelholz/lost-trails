extends Node2D

@export var layer_id: int = 0
@export var perspective_scale: float = 1.0
@export var player_y: float = 600.0


func _ready():

	add_to_group("layer")
