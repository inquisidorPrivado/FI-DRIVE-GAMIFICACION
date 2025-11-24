#token_window.gd
extends CanvasLayer

@export var token_alert:RichTextLabel

var token:String = ""
var user:int = 0

func _ready() -> void:
	#visible = false
	pass

func display_token_window(user_number:int, token_name:String) -> void:

	var random_positions = [Vector2(326, 149),Vector2(100, 280),Vector2(500, 200)]
	#Colocamos la ventana en una posición aleatoria
	$PanelContainer.position = random_positions[randi_range(0,2)]
	token_alert.text = "USUARIO_%s quiere modificar [shake]‘%s’[/shake]" % [user_number, token_name]
	token = token_name
	user = user_number
	var random_index:int = randi_range(0,1)
	match random_index:
		0:
			$PanelContainer/VBoxContainer/HBoxContainer.visible = true
			$PanelContainer/VBoxContainer/HBoxContainer2.visible = false
		1:
			$PanelContainer/VBoxContainer/HBoxContainer.visible = false
			$PanelContainer/VBoxContainer/HBoxContainer2.visible = true
	
	visible = true


func _on_acept_pressed() -> void:
	#GLOBALMANAGER.files_with_tokens
	print("Aceptar")
	if not GLOBALMANAGER.files_with_tokens[token][0]:
		GLOBALMANAGER.files_with_tokens[token][0] = true
		GLOBALMANAGER.files_with_tokens[token][1] = user
		visible = false
		get_tree().call_group("Gameplay", "end_token_window")
		
	else:
		get_tree().call_group("GameOver", "set_interface", "Token ya usado")




func _on_deny_pressed() -> void:
	if GLOBALMANAGER.files_with_tokens[token][0]:
		visible = false
		get_tree().call_group("Gameplay", "end_token_window")

		#GLOBALMANAGER.files_with_tokens[token][0] = true
		#GLOBALMANAGER.files_with_tokens[token][1] = user
	else:
		get_tree().call_group("GameOver", "set_interface", "Negaste el Token")
