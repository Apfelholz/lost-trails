extends Control

@export_file("*.tscn") var next_scene: String = ""

@export var effects: Array[CutsceneEffect] = []

@onready var fade_overlay: ColorRect = $EffectsLayer/FadeOverlay
@onready var vignette_overlay: ColorRect = $EffectsLayer/VignetteOverlay
@onready var blink_overlay: ColorRect = $EffectsLayer/BlinkOverlay


func _ready() -> void:
	vignette_overlay.material = vignette_overlay.material.duplicate()

	var vp_size := get_viewport().get_visible_rect().size
	for overlay in [fade_overlay, vignette_overlay, blink_overlay]:
		overlay.position = Vector2.ZERO
		overlay.size = vp_size
		overlay.visible = false

	_run_effects()

func _run_effects() -> void:
	var tween := create_tween()
	for step: CutsceneEffect in effects:
		_chain_step(tween, step)
	tween.tween_callback(_go_to_next_scene)

func _chain_step(tween: Tween, step: CutsceneEffect) -> void:
	match step.type:
		CutsceneEffect.Type.WAIT:
			tween.tween_interval(step.duration)

		CutsceneEffect.Type.FADE_IN:
			tween.tween_callback(func():
				fade_overlay.modulate.a = 1.0
				fade_overlay.visible = true
			)
			tween.tween_property(fade_overlay, "modulate:a", 0.0, step.duration)
			tween.tween_callback(func(): fade_overlay.visible = false)

		CutsceneEffect.Type.FADE_OUT:
			tween.tween_callback(func():
				fade_overlay.modulate.a = 0.0
				fade_overlay.visible = true
			)
			tween.tween_property(fade_overlay, "modulate:a", 1.0, step.duration)

		CutsceneEffect.Type.IRIS_OPEN:
			var mat := vignette_overlay.material as ShaderMaterial
			tween.tween_callback(func():
				mat.set_shader_parameter("iris_radius", 0.0)
				vignette_overlay.visible = true
			)
			tween.tween_method(
				func(v: float) -> void: mat.set_shader_parameter("iris_radius", v),
				0.0, 1.1, step.duration
			)
			tween.tween_callback(func(): vignette_overlay.visible = false)

		CutsceneEffect.Type.IRIS_CLOSE:
			var mat := vignette_overlay.material as ShaderMaterial
			tween.tween_callback(func():
				mat.set_shader_parameter("iris_radius", 1.1)
				vignette_overlay.visible = true
			)
			tween.tween_method(
				func(v: float) -> void: mat.set_shader_parameter("iris_radius", v),
				1.1, 0.0, step.duration
			)

		CutsceneEffect.Type.BLINK:
			tween.tween_callback(func():
				blink_overlay.modulate.a = 0.0
				blink_overlay.visible = true
			)
			var blink_time := step.duration / (float(step.blink_count) * 2.0)
			for _i in step.blink_count:
				tween.tween_property(blink_overlay, "modulate:a", 1.0, blink_time)
				tween.tween_property(blink_overlay, "modulate:a", 0.0, blink_time)
			tween.tween_callback(func(): blink_overlay.visible = false)


func _go_to_next_scene() -> void:
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
