extends StaticBody2D

var layer_id: int = 0


func _ready() -> void:
	# layer_id automatisch vom nächsten Layer-Elternknoten übernehmen
	var p = get_parent()
	while p != null:
		if p.get_script() != null and "layer_id" in p and "perspective_scale" in p:
			layer_id = p.layer_id
			break
		p = p.get_parent()

	add_to_group("obstacle_polygon")

	# StaticBody blockiert den Spieler physisch auf diesem Layer
	collision_layer = 1 << layer_id

	# LayerBlockArea bekommt zur Laufzeit eine Kopie des Polygons —
	# so gibt es im Editor nur eine editierbare Form ohne UndoRedo-Konflikte
	var main_col := get_node_or_null("CollisionPolygon2D") as CollisionPolygon2D
	var area := $LayerBlockArea
	if main_col != null:
		var block_col := CollisionPolygon2D.new()
		block_col.polygon = main_col.polygon
		block_col.position = main_col.position
		area.add_child(block_col)
	area.collision_mask = 1
	area.body_entered.connect(_on_block_entered)
	area.body_exited.connect(_on_block_exited)


func _on_block_entered(body: Node) -> void:
	if body.has_method("change_layer"):
		body.can_change_layer = false


func _on_block_exited(body: Node) -> void:
	if body.has_method("change_layer"):
		body.can_change_layer = true
