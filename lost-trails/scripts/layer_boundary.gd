@tool
extends Area2D

@export var layer_id: int = 0
@export var base_width: float = 2560
@export var base_height: float = 1440

@export_range(0, 1440, 1)
var height_reduction: float = 0:
	set(value):
		height_reduction = value
		update_boundary()

var shape: RectangleShape2D
var collision: CollisionShape2D


func _ready():
	add_to_group("layer_boundary")
	collision = get_node_or_null("CollisionShape2D")

	if collision:
		shape = (collision.shape as RectangleShape2D).duplicate()
		collision.shape = shape

	call_deferred("update_boundary")


func update_boundary():

	if !is_inside_tree():
		return

	if shape == null:
		return

	var width := base_width
	var height := base_height - height_reduction

	shape.size = Vector2(width, height)

	# Shape im Zentrum lassen
	if collision:
		collision.position = Vector2.ZERO
