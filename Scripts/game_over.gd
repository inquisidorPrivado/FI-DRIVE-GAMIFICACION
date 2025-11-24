extends CanvasLayer
@onready var run_duration_seconds:int = 0
@export var run_duration_timer:Timer
@export var run_duration_text:Label
@export var cause_text:Label


func _ready() -> void:
	run_duration_timer.start()

func set_interface(causante:String):
	get_tree().paused = true
	visible = true
	run_duration_timer.stop()
	run_duration_text.text = "Tiempo de la partida: " + format_time()
	cause_text.text = "Causa: "+causante
	#print(format_time())
	



func format_time() -> String:
	var minutes = run_duration_seconds / 60
	var seconds = run_duration_seconds - (60*minutes)
	
	# "%02d" significa: entero con al menos 2 dígitos, rellenado con ceros
	return "%d:%02d" % [minutes, seconds]



func _on_run_duration_timeout() -> void:
	run_duration_seconds += 1


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
