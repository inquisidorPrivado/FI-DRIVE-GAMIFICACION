extends Sprite2D


@export var game_over_timer:Timer
@export var maxium_processes_timer:Timer


@export var timer_text:RichTextLabel
@export var timer_container:PanelContainer
@onready var set_time:int = GLOBALMANAGER.bad_time
@onready var counter_timer:int = 0



@export var process_text:RichTextLabel
@export var maximum_processes_container:PanelContainer
@onready var maxium_processes:int = 5
@onready var current_processes:int = 0
@onready var index_server:String = ""


@export var load_balancing:Button

@onready var free_server:bool = true

func _ready() -> void:
	load_balancing.visible = false
	maximum_processes_container.visible = true
	timer_container.visible = false
	#var temporizador_aleatorio = randf_range(1.1, 2.1)
	#await get_tree().create_timer(temporizador_aleatorio).timeout
	
	#Activa el timer para agregar procesos, solo sirve para testear
	#La función que ocupamos está en la escena del Gameplay
	#set_maxium_processes_timer()




func set_maxium_processes_timer(set_current_process:int = 0):
	
	GLOBALMANAGER.server_dictionary[index_server] = set_current_process
	update_maxium_process_text()
	maximum_processes_container.visible = true
	maxium_processes_timer.start()
	
	

func update_timer_text():
	if counter_timer > 5:
		timer_text.text = "[shake rate=20.0 level=15 connected=0]%s[/shake]" % [counter_timer]
	else:
		timer_text.text = "[shake rate=20.0 level=30 connected=0]%s[/shake]" % [counter_timer]


func update_maxium_process_text():
	# Se mostrará normal el label
	if GLOBALMANAGER.server_dictionary[index_server] < 4:
		process_text.text = "Carga del servidor: %s/%s" % [GLOBALMANAGER.server_dictionary[index_server],maxium_processes]
	else: # Se mostrará el label con mucho shake para mostrar que ya casi se llena
		process_text.text = "[shake rate=20.0 level=15 connected=0]Carga del servidor: %s/%s[/shake]" % [GLOBALMANAGER.server_dictionary[index_server],maxium_processes]



func update_load_balancing_text():
	pass


func _on_maxium_processes_timer_timeout() -> void:
	GLOBALMANAGER.server_dictionary[index_server] += 1
	update_maxium_process_text()
	
	if GLOBALMANAGER.server_dictionary[index_server] >= maxium_processes:
		#Mostramos el botón
		load_balancing.visible = true
		timer_container.visible = true
		counter_timer = set_time
		update_timer_text()
		game_over_timer.start()
		#update_power_button_text()
		maxium_processes_timer.stop()


func activate_game_final_sequence():
	#Mostramos el botón
		load_balancing.visible = true
		timer_container.visible = true
		counter_timer = set_time
		update_timer_text()
		free_server = false
		game_over_timer.start()
		#update_power_button_text()
		maxium_processes_timer.stop()


func _on_game_over_timer_timeout() -> void:
	counter_timer -= 1
	update_timer_text()
	if counter_timer <= 0:
		print("Perdiste mi pana")
		get_tree().call_group("GameOver", "set_interface", "NO balanceaste la carga")

		#get_tree().paused = true


func _on_load_balancing_pressed() -> void:
	#print("papepipopu")
	free_server = true
	
	game_over_timer.stop()
	counter_timer = set_time
	timer_container.visible = false
	#set_maxium_processes_timer()
	GLOBALMANAGER.text_animation("La carga ha sido balanceada")

	get_tree().call_group("Gameplay", "process_load_balancing")
	
	load_balancing.visible = false
	
