extends Area2D

## Die Zielszene, zu der gewechselt wird (z.B. "res://scenes/GameScenes/level2.tscn").
@export_file("*.tscn") var target_scene: String = ""
## -1 = automatisch vom Layer-Elternknoten übernehmen.
@export var required_layer_id: int = -1

var layer_id: int = 0
var _triggered: bool = false


func _ready() -> void:
	if required_layer_id >= 0:
		layer_id = required_layer_id
	else:
		# layer_id automatisch vom nächsten Layer-Elternknoten übernehmen.
		# Wir prüfen NICHT is_in_group("layer"), weil _ready() der Parents
		# noch nicht gelaufen ist wenn dieser Node initialisiert wird.
		var parent = get_parent()
		while parent != null:
			if parent.get_script() != null and parent.get("layer_id") != null and parent.get("perspective_scale") != null:
				layer_id = int(parent.get("layer_id"))
				break
			parent = parent.get_parent()

	# collision_mask = 1 damit der Player (immer auf Physics-Layer 1) erkannt wird.
	# Die Spieler-Layer-Prüfung übernimmt der Code in _on_body_entered.
	collision_mask = 1
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _triggered:
		return

	if target_scene == "":
		push_warning("SceneTrigger: Keine Zielszene gesetzt!")
		return

	# Nur der Player darf auslösen.
	if not body.has_method("change_layer"):
		return

	# Nur auslösen, wenn der Player denselben Layer hat.
	if int(body.get("current_layer")) != layer_id:
		return

	_triggered = true
	get_tree().call_deferred("change_scene_to_file", target_scene)
