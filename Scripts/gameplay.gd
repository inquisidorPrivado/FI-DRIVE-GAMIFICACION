#gameplay.gd
extends Control

@export var server_1_text:Sprite2D
@export var server_2_text:Sprite2D
@export var server_3_text:Sprite2D
@export var server_4_text:Sprite2D
@export var server_5_text:Sprite2D

@export var mutual_lockout:CanvasLayer
@export var head_bar:CanvasLayer
@export var token_window_node:CanvasLayer

@export var process_assignment:Timer


@onready var token_mecanic:bool = false
@onready var mutual_lockout_mecanic:bool = false


@onready var list_of_users = []
@onready var list_of_files = ["Dead Cells.exe", "Balatro.csv", "Hollow_Knight.docx"]

#@onready var users_generator:int = 0

func _ready() -> void:
	process_assignment.wait_time = GLOBALMANAGER.velocity
	#Creamos una cantidad de usuarios
	for i in 25:
		list_of_users.append([true,list_of_files[randi_range(0,2)]])
	
	reset_server_numbers()
	reset_tokens()
	server_1_text.index_server = "server_1"
	server_2_text.index_server = "server_2"
	server_3_text.index_server = "server_3"
	server_4_text.index_server = "server_4"
	server_5_text.index_server = "server_5"
	
	process_assignment.start()

func token_window(user_number:int, token_name:String)-> void:
	#Mandaremos la info al nodo, él se ecnargará de checar toda la info
	token_mecanic = true
	token_window_node.display_token_window(user_number, token_name)
	head_bar.create_notification("USUARIO_"+str(user_number), token_name, true)

func end_token_window() -> void:
	token_mecanic = false

func reset_tokens()-> void:
	for token_name in GLOBALMANAGER.files_with_tokens:
		GLOBALMANAGER.files_with_tokens[token_name] = [false,0]

func start_mutual_lockout():
	#print("Sí se ejecuta")
	mutual_lockout_mecanic = true
	var index_1:String = ""
	var index_2:String = ""
	var count:int = 0
	var type_sort:int = randi_range(0,1)
	match type_sort:
		0:
			for token_name in GLOBALMANAGER.files_with_tokens:
		
				if GLOBALMANAGER.files_with_tokens[token_name][0]:
					count +=1
					if count==1:
						index_1 = token_name
					elif count==2:
						index_2 = token_name
						mutual_lockout.set_mutual_lockout_description(index_1,index_2)
						break
		1:
			var lista_llaves = GLOBALMANAGER.files_with_tokens.keys()
			lista_llaves.reverse()
			for token_name in lista_llaves:
				if GLOBALMANAGER.files_with_tokens[token_name][0]:
					count +=1
					if count==1:
						index_1 = token_name
					elif count==2:
						index_2 = token_name
						mutual_lockout.set_mutual_lockout_description(index_1,index_2)
						break
	
	
 

func end_mutual_lockout():
	mutual_lockout_mecanic = false



func reset_server_numbers()-> void:
	for index in 5:
		#print("Listo")
		var create_index = "server_"+str(1+index)
		GLOBALMANAGER.server_dictionary[create_index] = 0
		get_tree().call_group("Snapshot", "update_server_load_text")


# Si un server tiene 6 procesos, ya no le cabe NADA más, ni por error.
const HARD_LIMIT = 5

func _on_process_assignment_timeout() -> void:
	# Elegimos un servidor al azar (del 1 al 5)
	var server_index: int = randi_range(1, 5)
	var chosen_server: String = "server_" + str(server_index)
	
	# Obtenemos referencia al nodo visual y la carga actual
	var modified_server = get(chosen_server + "_text")
	var current_load = GLOBALMANAGER.server_dictionary[chosen_server]
	
	var azar: float = randf()
	var accion_realizada: bool = false # Para saber si hicimos algo especial
	
	# --- LÓGICA DE SALIDA / TOKENS (Solo si hay carga > 2) ---
	if current_load > 0 and current_load < 6:
		
		# 1. INTENTO DE TOKEN (20%)
		if azar < 0.2 and not token_mecanic:
			var random_user_idx = randi() % list_of_users.size()
			var user_data = list_of_users[random_user_idx] # [estado, nombre_archivo]
			
			# Si el archivo NO tiene token asignado aún--------------------------------------------------------
			if not GLOBALMANAGER.files_with_tokens[user_data[1]][0]:
				# Asignamos token
				list_of_users[random_user_idx][0] = false # Usuario ocupado
				#Colocamos que ya está ocupado en el diccionario global junto con el usuario
				token_window(random_user_idx, user_data[1])
				return # Terminamos el turno aquí exitosamente
			else:
				#Si el token está siendo utilizada
				#Habrá tres opciones: Trollear, que el usuario terminó o que hay un bloqueo mutuo(necesitamos dos tokens ocupados)
				var count:int = 0
				#Revisamos si es posible realizar un bloqueo mutuo
				for token_name in GLOBALMANAGER.files_with_tokens:
					if GLOBALMANAGER.files_with_tokens[token_name][0]:
						count+=1
				
				#Veremos si es posible trollear o terminar la modificación del archivo
				var suerte: float = randf()
				
				
				#Probamos el bloqueo mutuo
				if suerte<=0.1 and count>=2 and not mutual_lockout_mecanic:
					start_mutual_lockout()
				elif  suerte <= 0.125 and not token_mecanic and not mutual_lockout_mecanic: #probamos terminar la modificación
					for token_name in GLOBALMANAGER.files_with_tokens:
						if GLOBALMANAGER.files_with_tokens[token_name][0]:
							#Mostramos que se termino de modificar el archivo
							head_bar.end_modification_notification("USUARIO_"+str(GLOBALMANAGER.files_with_tokens[token_name][1]),token_name)
							list_of_users[GLOBALMANAGER.files_with_tokens[token_name][1]][0] = true
							GLOBALMANAGER.files_with_tokens[token_name][0]=false
							GLOBALMANAGER.files_with_tokens[token_name][1]=0
							break
					return
				elif  suerte <= 0.15 and not token_mecanic: #Intentamos trollear
					for token_name in GLOBALMANAGER.files_with_tokens:
						if GLOBALMANAGER.files_with_tokens[token_name][0]:
							token_window(randi_range(0,23), token_name)
							break
					return
				#print("Intento de token fallido (ya ocupado), pasamos a sumar proceso normal...")
				# No hacemos return, dejamos que el código fluya hacia abajo para agregar proceso
		
		# 2. INTENTO DE ELIMINAR USUARIO (20% del total, si cae entre 0.2 y 0.4)
		elif azar < 0.6:
			# Buscamos un usuario ocupado para liberarlo
			for i in list_of_users.size():
				if list_of_users[i][0] == false: # Si está ocupado
					list_of_users[i][0] = true # ¡LO LIBERAMOS! (Corrección aquí)
					
					var name_user: String = "USUARIO_" + str(i)
					head_bar.create_notification(name_user, list_of_users[i][1], false, true)
					
					# Restamos proceso al servidor
					GLOBALMANAGER.server_dictionary[chosen_server] -= 1
					modified_server.update_maxium_process_text()
					#print("Opción 2: Usuario " + name_user + " desconectado.")
					return # Terminamos el turno
	
	# --- LÓGICA DE ENTRADA (Si no se hizo nada arriba o falló el token) ---
	# Verificar colapso del sistema
	if GLOBALMANAGER.server_dictionary[chosen_server] >= 5 and modified_server.free_server: # ¿Era 5 o HARD_LIMIT? Cuidado aquí
		modified_server.activate_game_final_sequence()
		return
	# 1. Verificamos límite duro
	if current_load >= HARD_LIMIT:
		#print(chosen_server + " RECHAZÓ conexión (Lleno)")
		return

	# 2. Sumamos proceso
	var random_user_idx = randi() % list_of_users.size()
	list_of_users[random_user_idx][0] = false # Ocupamos al usuario
	
	var name_user: String = "USUARIO_" + str(random_user_idx)
	head_bar.create_notification(name_user, list_of_users[random_user_idx][1])
	
	GLOBALMANAGER.server_dictionary[chosen_server] += 1
	modified_server.update_maxium_process_text()
	
	



#Esta función la activa el botón de balancear carga
func process_load_balancing() -> void:
	# PASO 1: Calcular el total de procesos en todo el sistema
	var total_procesos = 0
	for index in GLOBALMANAGER.server_dictionary:
		total_procesos += GLOBALMANAGER.server_dictionary[index]

	# PASO 2: Calcular cuántos le tocan a cada uno (Promedio)
	# Si hay 13 procesos y 5 servers: 13 / 5 = 2 (división entera)
	var promedio:int = total_procesos / 5
	
	# PASO 3: Calcular el residuo (los que sobran tras dividir equitativamente)
	# 13 % 5 = 3 procesos sobrantes
	var sobrantes = total_procesos % 5

	# PASO 4: Redistribuir (MIGRACIÓN)
	for i in range(5):
		var chosen_server:String = "server_"+str(i+1)
		
		if i < sobrantes:
			## Los primeros servidores se llevan el promedio + 1 del sobrante
			GLOBALMANAGER.server_dictionary["server_"+str(i+1)] = promedio
			
		else:
			# Los demás se quedan con el promedio exacto
			GLOBALMANAGER.server_dictionary["server_"+str(i+1)] = promedio
		var modified_server = get(chosen_server+"_text")
		modified_server.update_maxium_process_text()
	#print("¡Carga balanceada! Nuevo estado: ", servidores)
