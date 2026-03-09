@tool
extends Area2D

@export var layer_id:int = 0

@export var auto_fit_view: bool = true
@export var width_scale: float = 1.0
@export var height_scale: float = 1.0

@export var left:float = -400
@export var right:float = 400
@export var top:float = -200
@export var bottom:float = 200

var collision_shape_node:CollisionShape2D
var rect_shape:RectangleShape2D
var visual_rect:ColorRect

var dragging = ""
var handle_size = 10


func _ready():

	add_to_group("layer_boundary")

	collision_shape_node = get_node_or_null("CollisionShape2D")
	visual_rect = get_node_or_null("ColorRect")

	if collision_shape_node and collision_shape_node.shape:
		rect_shape = collision_shape_node.shape

	update_boundary()


func update_boundary():

	if rect_shape == null:
		return

	var width = right - left
	var height = bottom - top

	if auto_fit_view:
		var viewport_size: Vector2 = get_viewport_rect().size
		if viewport_size.x > 0 and viewport_size.y > 0:
			width = viewport_size.x * width_scale
			height = viewport_size.y * height_scale
			left = -width / 2
			right = width / 2
			top = -height / 2
			bottom = height / 2

	rect_shape.size = Vector2(width, height)

	var center = Vector2(
		(left + right) / 2,
		(top + bottom) / 2
	)

	if collision_shape_node:
		collision_shape_node.position = center

	if visual_rect:
		visual_rect.size = Vector2(width, height)
		visual_rect.position = center - visual_rect.size / 2


func _draw():

	if !Engine.is_editor_hint():
		return

	var rect = Rect2(
		Vector2(left, top),
		Vector2(right - left, bottom - top)
	)

	draw_rect(rect, Color(0,0.7,1,0.15), true)
	draw_rect(rect, Color(0,0.7,1), false, 2)

	draw_circle(Vector2(left,top), handle_size, Color.RED)
	draw_circle(Vector2(right,top), handle_size, Color.RED)
	draw_circle(Vector2(left,bottom), handle_size, Color.RED)
	draw_circle(Vector2(right,bottom), handle_size, Color.RED)


func _process(delta):

	if Engine.is_editor_hint():
		queue_redraw()


func _input(event):

	if !Engine.is_editor_hint():
		return

	if event is InputEventMouseButton:

		if event.pressed:

			var p = get_local_mouse_position()

			if p.distance_to(Vector2(left,top)) < handle_size:
				dragging = "lt"

			elif p.distance_to(Vector2(right,top)) < handle_size:
				dragging = "rt"

			elif p.distance_to(Vector2(left,bottom)) < handle_size:
				dragging = "lb"

			elif p.distance_to(Vector2(right,bottom)) < handle_size:
				dragging = "rb"

		else:
			dragging = ""


	if event is InputEventMouseMotion and dragging != "":

		var p = get_local_mouse_position()

		match dragging:

			"lt":
				left = p.x
				top = p.y

			"rt":
				right = p.x
				top = p.y

			"lb":
				left = p.x
				bottom = p.y

			"rb":
				right = p.x
				bottom = p.y

		update_boundary()
