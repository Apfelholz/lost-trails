extends StaticBody2D

@export var layer_id: int = 0


func _ready():

	collision_layer = 1 << layer_id

	update_depth()


func update_depth():

	z_index = int(global_position.y)