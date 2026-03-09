extends Area2D


func _ready():

	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)


func _on_enter(body):

	if body.has_method("change_layer"):
		body.can_change_layer = false


func _on_exit(body):

	if body.has_method("change_layer"):
		body.can_change_layer = true