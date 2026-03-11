extends Area2D

## Die Zielszene, zu der gewechselt wird (z.B. "res://scenes/GameScenes/level2.tscn").
@export_file("*.tscn") var target_scene: String = ""

var layer_id: int = 0


func _ready() -> void:
	# layer_id automatisch vom nächsten Layer-Elternknoten übernehmen.
	# Wir prüfen NICHT is_in_group("layer"), weil _ready() der Parents
	# noch nicht gelaufen ist wenn dieser Node initialisiert wird.
	var parent = get_parent()
	while parent != null:
		if parent.get_script() != null and "layer_id" in parent and parent.get("perspective_scale") != null:
			layer_id = parent.layer_id
			break
		parent = parent.get_parent()

	# collision_mask = 1 damit der Player (immer auf Physics-Layer 1) erkannt wird.
	# Die Spieler-Layer-Prüfung übernimmt der Code in _on_body_entered.
	collision_mask = 1
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if target_scene == "":
		push_warning("SceneTrigger: Keine Zielszene gesetzt!")
		return

	# Nur auslösen, wenn der Player denselben Layer hat
	if body.has_method("change_layer") and body.get("current_layer") != layer_id:
		return

	get_tree().call_deferred("change_scene_to_file", target_scene)
