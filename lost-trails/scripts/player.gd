extends CharacterBody2D

@export var speed: float = 220.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0

var current_layer: int = 0
var can_change_layer: bool = true
var on_boundary_floor: bool = false

var layers := []
var boundaries := []
var current_boundary: Area2D = null
var layers_by_id := {}
var boundaries_by_id := {}

func _ready():
	call_deferred("_init_layers_and_boundaries")

func _physics_process(delta):
	if current_boundary == null or boundaries_by_id.is_empty() or layers_by_id.is_empty():
		_init_layers_and_boundaries()

	var s: float = scale.x  # perspective_scale des aktuellen Layers

	var direction := 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	velocity.x = direction * speed * s

	if not is_on_floor() and not on_boundary_floor:
		velocity.y += gravity * s * delta

	if Input.is_action_just_pressed("jump") and (is_on_floor() or on_boundary_floor):
		velocity.y = jump_force * s
		on_boundary_floor = false

	if can_change_layer:
		if Input.is_action_just_pressed("move_forward"):
			change_layer(1)
		if Input.is_action_just_pressed("move_back"):
			change_layer(-1)

	move_and_slide()
	limit_to_boundary()
	update_depth()

func _init_layers_and_boundaries():
	layers = get_tree().get_nodes_in_group("layer")
	boundaries = get_tree().get_nodes_in_group("layer_boundary")
	layers_by_id.clear()
	boundaries_by_id.clear()
	for l in layers:
		layers_by_id[l.layer_id] = l
	for b in boundaries:
		boundaries_by_id[b.layer_id] = b
	apply_layer()
	update_boundary()
	limit_to_boundary()

func change_layer(dir: int):
	var new_layer := current_layer + dir
	if not layers_by_id.has(new_layer):
		return

	var prev_boundary := current_boundary
	var prev_bottom: float = _get_boundary_bottom(prev_boundary)

	current_layer = new_layer
	apply_layer()  # setzt Scale, position
	update_boundary()  # <-- sicherstellen, dass Boundary sofort gesetzt wird

	var new_bottom: float = _get_boundary_bottom(current_boundary)
	if not is_nan(prev_bottom) and not is_nan(new_bottom):
		position.y += new_bottom - prev_bottom

	limit_to_boundary()
	
func update_boundary():
	current_boundary = boundaries_by_id.get(current_layer, null)

# Layer anwenden
func apply_layer():
	var layer = layers_by_id.get(current_layer, null)
	if layer == null:
		return
	scale = Vector2(layer.perspective_scale, layer.perspective_scale)
	collision_mask = 1 << current_layer

# Spieler auf aktuelle Boundary beschränken
func limit_to_boundary():
	if current_boundary == null:
		on_boundary_floor = false
		return
	var shape_node: CollisionShape2D = current_boundary.get_node_or_null("CollisionShape2D")
	if shape_node == null or shape_node.shape == null:
		on_boundary_floor = false
		return
	var boundary_shape = shape_node.shape
	if boundary_shape is RectangleShape2D:
		var size = boundary_shape.size
		var center = current_boundary.to_global(shape_node.position)
		var left = center.x - size.x / 2
		var right = center.x + size.x / 2
		var top = center.y - size.y / 2
		var bottom = center.y + size.y / 2

		# Eigene CollisionShape einbeziehen, damit der Spieler nicht durch die Ränder ragt
		var player_col: CollisionShape2D = get_node_or_null("CollisionShape2D")
		if player_col != null and player_col.shape is RectangleShape2D:
			var ps := player_col.shape as RectangleShape2D
			# col_offset und half_ext im Weltkoordinatensystem (skaliert)
			var col_offset: Vector2 = player_col.position * scale
			var half_ext: Vector2 = ps.size / 2.0 * scale
			var bottom_clamp: float = bottom - col_offset.y - half_ext.y
			position.x = clamp(position.x, left - col_offset.x + half_ext.x, right - col_offset.x - half_ext.x)
			position.y = clamp(position.y, top - col_offset.y + half_ext.y, bottom_clamp)
			on_boundary_floor = position.y >= bottom_clamp - 1.0
		else:
			position.x = clamp(position.x, left, right)
			position.y = clamp(position.y, top, bottom)
			on_boundary_floor = position.y >= bottom - 1.0

func _get_boundary_bottom(boundary: Area2D) -> float:
	if boundary == null:
		return NAN
	var shape_node: CollisionShape2D = boundary.get_node_or_null("CollisionShape2D")
	if shape_node == null or shape_node.shape == null:
		return NAN
	var shape = shape_node.shape
	if shape is RectangleShape2D:
		var size = shape.size
		var center = boundary.to_global(shape_node.position)
		return center.y + size.y / 2
	return NAN

func update_depth():
	# Perspektivfaktor pro Layer
	var scale_factor := 1.0
	var layer_offset := current_layer * 1000
	var layer = layers_by_id.get(current_layer, null)
	if layer != null:
		scale_factor = layer.perspective_scale

	# z_index innerhalb eines sicheren Bereichs
	var z := int(global_position.y * scale_factor) + layer_offset
	z_index = clamp(z, -4096, 4096)
