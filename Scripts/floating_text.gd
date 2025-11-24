#floating_text.gd
extends CanvasLayer

@onready var interface: Control = $Interface
@onready var text_label: Label = $Interface/Text

func create_text(display_text: String, spawn_position: Vector2 = Vector2(456, 298), text_color: Color = Color.WHITE) -> void:
	text_label.text = display_text
	text_label.position = spawn_position

	var material := text_label.material
	if material and material is ShaderMaterial:
		# Duplicamos para que cada instancia tenga su propio shader independiente
		material = material.duplicate()
		text_label.material = material
		material.set_shader_parameter("text_color", Color(text_color.r, text_color.g, text_color.b, 1.0))  # Color visible al inicio

	var tween := create_tween()
	tween.set_parallel()

	# Movimiento hacia arriba
	tween.tween_property(
		interface,
		"position",
		interface.position + Vector2(0, -70),
		2.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Desvanecimiento simultáneo
	tween.tween_method(
		func(a):
			if material:
				material.set_shader_parameter("text_color", Color(text_color.r, text_color.g, text_color.b, a)),
		1.0, 0.0, 0.8
	)

	tween.finished.connect(queue_free)
