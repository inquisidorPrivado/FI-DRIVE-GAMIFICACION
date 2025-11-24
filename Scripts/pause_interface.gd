extends CanvasLayer

@export var server_1_text:Label
@export var server_2_text:Label
@export var server_3_text:Label
@export var server_4_text:Label
@export var server_5_text:Label

@export var token_1_text:RichTextLabel
@export var token_2_text:RichTextLabel
@export var token_3_text:RichTextLabel


@onready var main_menu:PackedScene = load("res://Scenes/main_menu.tscn")

func _ready() -> void: 
	update_server_load_text()


func update_server_load_text() -> void:
	#var base_text:String = ""
	server_1_text.text = "Carga del Servidor 1: %s/5" % [GLOBALMANAGER.server_dictionary["server_1"]]
	server_2_text.text = "Carga del Servidor 2: %s/5" % [GLOBALMANAGER.server_dictionary["server_2"]]
	server_3_text.text = "Carga del Servidor 3: %s/5" % [GLOBALMANAGER.server_dictionary["server_3"]]
	server_4_text.text = "Carga del Servidor 4: %s/5" % [GLOBALMANAGER.server_dictionary["server_4"]]
	server_5_text.text = "Carga del Servidor 5: %s/5" % [GLOBALMANAGER.server_dictionary["server_5"]]
	
	var count:int = 0
	for token_name in GLOBALMANAGER.files_with_tokens:
		count+=1
		var token_node = get("token_"+str(count)+"_text")
		print(token_name)
		if GLOBALMANAGER.files_with_tokens[token_name][0]:
			var user_name:String = str(GLOBALMANAGER.files_with_tokens[token_name][1])
			token_node.text = "[rainbow freq=0.1 sat=0.9 val=0.9 speed=1.0]Token '%s': En uso por USUARIO_%s[/rainbow]" % [token_name,user_name]
		else:#El token está libre
			token_node.text = "Token '%s': Libre" % [token_name]
	
	


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
