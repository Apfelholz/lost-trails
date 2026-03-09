extends Sprite2D

func _ready():
	# Scale and center to cover the current viewport
	if texture == null:
		return
	var tex_size: Vector2 = texture.get_size()
	var viewport_size: Vector2 = get_viewport_rect().size
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return
	var scale_x: float = viewport_size.x / tex_size.x
	var scale_y: float = viewport_size.y / tex_size.y
	var s: float = max(scale_x, scale_y)
	scale = Vector2(s, s)
	position = viewport_size * 0.5
