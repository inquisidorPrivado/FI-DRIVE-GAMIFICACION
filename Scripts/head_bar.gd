extends CanvasLayer

@export var pause_interface:CanvasLayer
@export var message_text:RichTextLabel

func _ready() -> void:
	message_text.text = ""

func _on_pause_pressed() -> void:
	# 1. Detener todo (físicas, enemigos, movimiento)
	get_tree().call_group("Snapshot", "update_server_load_text")
	get_tree().paused = true
	pause_interface.visible = true
	
func end_modification_notification(user:String,file_name:String):
	message_text.text = "[wave]%s[/wave] [rainbow freq=0.1 sat=0.9 val=0.9 speed=1.0]TERMINO DE MODIFICAR[/rainbow] el archivo [wave]%s[/wave]" % [user,file_name]
	

func create_notification(user:String,file_name:String, is_modifying:bool=false, is_leave:bool = false):
	match is_leave:
		false:
			if is_modifying:
				message_text.text = "[wave]%s[/wave] quiere [rainbow freq=0.1 sat=0.9 val=0.9 speed=1.0]MODIFICAR[/rainbow] el archivo [wave]%s[/wave]" % [user,file_name]
			else:
				message_text.text = "[wave]%s[/wave] está accediendo al archivo [wave]%s[/wave]" % [user, file_name]
		true:
			message_text.text = "[wave]%s[/wave] está saliéndose el archivo [wave]%s[/wave]" % [user,file_name]
