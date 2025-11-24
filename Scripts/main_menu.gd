#main_menu.gd
extends Control


#Enlace del shader del fondo
#https://godotshaders.com/shader/pixel-perfect-halo-radiant-glow/

#Enlace del shader del logo
#https://godotshaders.com/shader/random-displacement-animation-easy-ui-animation/


@export var transitions:CanvasLayer

@export var main_options_container:PanelContainer
@export var second_options_container:PanelContainer

@onready var new_game:PackedScene = preload("res://Scenes/gameplay.tscn")


@export var new_game_button:Button
@export var tutorial_button:Button
@export var return_button:Button
@export var continuar_button:Button


func _ready() -> void:
	main_options_container.visible = true
	transitions.visible = true
	await get_tree().create_timer(1.0).timeout
	transitions.fade_in(1.0)


func _on_play_pressed() -> void:
	main_options_container.visible = false
	second_options_container.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_return_pressed() -> void:
	main_options_container.visible = true
	second_options_container.visible = false





func _on_extreme_pressed() -> void:
	GLOBALMANAGER.velocity = 0.05
	GLOBALMANAGER.bad_time = 6
	await transitions.fade_out(1.0)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(new_game)


func _on_normal_pressed() -> void:
	GLOBALMANAGER.velocity = 0.1
	GLOBALMANAGER.bad_time = 10
	await transitions.fade_out(1.0)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(new_game)
