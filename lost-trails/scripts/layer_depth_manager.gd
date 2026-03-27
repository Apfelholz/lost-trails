extends Node2D

var player: CharacterBody2D
var layers_by_id := {}

func _ready():
	call_deferred("_init_layers")

func _physics_process(_delta):
	if player != null:
		update_layer_depths()

func _init_layers():
	player = get_parent().get_node("Player")
	layers_by_id.clear()
	
	# Alle Kinder dieses Containers sind die Layer
	for child in get_children():
		if child.has_meta("layer_id") or (child.is_in_group("layer")):
			# Layer hat layer_id als Property
			if "layer_id" in child:
				layers_by_id[child.layer_id] = child
	
	update_layer_depths()

func update_layer_depths():
	if player == null:
		return
	
	var player_layer = player.current_layer
	
	# Player hat z_index = 1 (immer vor dem Hintergrund mit z_index = -1)
	player.z_index = 1
	
	# Alle Layer durchgehen und z_index setzen
	for layer_id in layers_by_id.keys():
		var layer = layers_by_id[layer_id]
		if layer_id < player_layer:
			# Layer mit niedrigerer ID als Player → vor dem Player
			layer.z_index = player_layer + 1 - layer_id
		else:
			# Layer mit gleicher oder höherer ID → hinter dem Player
			layer.z_index = 0
