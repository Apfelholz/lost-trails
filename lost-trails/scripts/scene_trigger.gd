extends Area2D

@export_file("*.tscn") var target_scene: String = ""
@export var required_layer_id: int = -1

var layer_id: int = 0
var _triggered: bool = false


func _ready() -> void:
	if required_layer_id >= 0:
		layer_id = required_layer_id
	else:
		var parent = get_parent()
		while parent != null:
			if parent.get_script() != null and parent.get("layer_id") != null and parent.get("perspective_scale") != null:
				layer_id = int(parent.get("layer_id"))
				break
			parent = parent.get_parent()

	collision_mask = 1
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _triggered:
		return

	if target_scene == "":
		push_warning("SceneTrigger: Keine Zielszene gesetzt!")
		return

	if not body.has_method("change_layer"):
		return

	if int(body.get("current_layer")) != layer_id:
		return

	_triggered = true
	get_tree().call_deferred("change_scene_to_file", target_scene)
