#transitions.gd
extends CanvasLayer

@export var background: ColorRect

## Ajustes personalizables
@export var default_color: Color = Color.BLACK
@export var default_duration: float = 1.5

func _ready():
	background.color = default_color
	background.modulate.a = 1.0  # Comienza opaco (negro)
	#visible = true
	#await get_tree().create_timer(2.5).timeout
	#fade_in()
	#await get_tree().create_timer(2.5).timeout
	#fade_out()
	#await get_tree().create_timer(2.5).timeout
	#
	#fade_in()
	


## --- Transición de OSCURECER (fade out)
func fade_out(duration: float = default_duration, color: Color = default_color) -> void:
	background.color = color
	visible = true
	await _tween_opacity(0.0, 1.0, duration)
	

## --- Transición de ACLARAR (fade in)
func fade_in(duration: float = default_duration, color: Color = default_color) -> void:
	background.color = color
	visible = true
	await _tween_opacity(1.0, 0.0, duration)
	visible = false


## --- Función auxiliar interna ---
func _tween_opacity(from_alpha: float, to_alpha: float, duration: float) -> Signal:
	var tween := create_tween()
	background.modulate.a = from_alpha
	tween.tween_property(background, "modulate:a", to_alpha, duration)
	await tween.finished
	return tween.finished
