#GLOBALMANAGER.gd
extends Node

var velocity:float = 0.09
var bad_time:int

var floating_text:PackedScene = load("res://Scenes/floating_text.tscn")
func text_animation(animate_text:String, text_position:Vector2 = Vector2(456, 318), text_color: Color = Color("#b03d00")):
	var new_floating_text = floating_text.instantiate()
	# Añadirlo a la escena (usa un nodo padre adecuado, por ejemplo get_tree().current_scene o un CanvasLayer)
	get_tree().current_scene.add_child(new_floating_text)
	# Llamar a la animación o método con los parámetros
	new_floating_text.create_text(animate_text, text_position, text_color)


@onready var server_dictionary:Dictionary[String, int] = {
	server_1=0,
	server_2=0,
	server_3=0,
	server_4=0,
	server_5=0
	
	
}
#[está en uso, usuario]
@onready var files_with_tokens:Dictionary = {
	"Dead Cells.exe": [false,0],
	 "Balatro.csv": [false,0],
	 "Hollow_Knight.docx": [false,0]
}
