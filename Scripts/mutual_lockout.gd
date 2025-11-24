#mutual_lockout.gd
extends CanvasLayer

@export var title_text:RichTextLabel
@export var description:RichTextLabel
@export var break_the_cycle_button:Button

@export var random_position_timer:Timer
var id_1:String
var id_2:String


func set_mutual_lockout_description(index_1:String, index_2:String):
	visible = true
	break_the_cycle_button.visible = true
	random_position_timer.start()
	id_1=index_1
	id_2=index_2
	var number_1:int = GLOBALMANAGER.files_with_tokens[index_1][1]
	var number_2:int = GLOBALMANAGER.files_with_tokens[index_2][1]
	
	description.text = "El Proceso_%s tiene el archivo '%s' y pide el archivo '%s'. El Proceso_%s tiene el archivo '%s' y pide el archivo '%s'" % [number_1,index_1,index_2,number_2,index_2,index_1]
	



func _on_random_position_timer_timeout() -> void:
	var random_positions = [Vector2(5, 50),Vector2(420, 180),Vector2(820, 50),Vector2(426, 540)]
	break_the_cycle_button.position = random_positions[randi_range(0,3)]


func _on_break_the_cycle_pressed() -> void:
	visible = false
	break_the_cycle_button.visible = false
	random_position_timer.stop()
	
	GLOBALMANAGER.files_with_tokens[id_1][0]= false
	GLOBALMANAGER.files_with_tokens[id_1][1] = 0
	
	GLOBALMANAGER.files_with_tokens[id_2][0] = false
	GLOBALMANAGER.files_with_tokens[id_2][1] = 0
	get_tree().call_group("Gameplay", "end_mutual_lockout")
