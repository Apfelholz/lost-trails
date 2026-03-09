extends CharacterBody2D

@export var speed: float = 220.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0

var current_layer: int = 0
var can_change_layer: bool = true

var layers := []
var boundaries := []
var current_boundary: Area2D = null


func _ready():

	layers = get_tree().get_nodes_in_group("layer")
	boundaries = get_tree().get_nodes_in_group("layer_boundary")

	apply_layer()


func _physics_process(delta):

	var direction := 0

	if Input.is_action_pressed("move_left"):
		direction -= 1

	if Input.is_action_pressed("move_right"):
		direction += 1

	velocity.x = direction * speed

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	if can_change_layer:

		if Input.is_action_just_pressed("move_forward"):
			change_layer(1)

		if Input.is_action_just_pressed("move_back"):
			change_layer(-1)

	move_and_slide()

	limit_to_boundary()

	update_depth()


func change_layer(dir: int):

	var new_layer := current_layer + dir

	var target_layer = null

	for l in layers:
		if l.layer_id == new_layer:
			target_layer = l

	if target_layer == null:
		return

	current_layer = new_layer

	apply_layer()


func apply_layer():

	for l in layers:

		if l.layer_id == current_layer:

			scale = Vector2(l.perspective_scale, l.perspective_scale)

			position.y = l.player_y

			collision_mask = 1 << current_layer

	for b in boundaries:

		if b.layer_id == current_layer:

			current_boundary = b


func limit_to_boundary():

	if current_boundary == null:
		return

	var shape = current_boundary.get_node("CollisionShape2D").shape

	if shape is RectangleShape2D:

		var size = shape.size
		var center = current_boundary.global_position

		var left = center.x - size.x / 2
		var right = center.x + size.x / 2
		var top = center.y - size.y / 2
		var bottom = center.y + size.y / 2

		position.x = clamp(position.x, left, right)
		position.y = clamp(position.y, top, bottom)


func update_depth():

	z_index = int(global_position.y)