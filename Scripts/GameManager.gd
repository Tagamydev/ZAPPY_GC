extends Node3D


var island = preload("res://Prefabs/island.tscn")
var player = preload("res://Prefabs/player.tscn")
var egg = preload("res://Prefabs/Egg.tscn")
var	island_x : int = 10
var island_y : int = 11
var island_total_x = 0
var island_total_y = 0
var players: Array = []
var players_list: Dictionary = {}

var tiles: Array = []
var tile_dic: Dictionary = {}

var players_in_tiles: Dictionary = {}

var teams: Array = []
var teams_dic: Dictionary = {}
var time = 100


func get_standar_duration():
	return float(7.0 * 1.0 / float(time))


func move_player(id, x, y):
	if players_list.has(id):
		var char: Characters = players_list[id].Character
		var key = str(char.x, ", ", char.y)
		var key2 = str(x, ", ", y)

		if players_in_tiles.has(key):
			players_in_tiles[key].erase(id)
		
		if not players_in_tiles.has(key2):
			players_in_tiles[key2] = []
			
		players_in_tiles[key2].append(id)
		
		char.x = int(x)
		char.y = int(y)

		# Get the player node (actual scene node, not the data)
		var player_node = players_list[id] # Make sure this is a Node3D

		# Get the correct tile index
		var tile: Node3D = tiles[tile_dic[key2]]

		# Get walkable plane
		var walk_plane = tile.get_node("walkPlane") as MeshInstance3D

		# Get mesh bounds
		var mesh_aabb = walk_plane.get_mesh().get_aabb()

		# Pick a random point inside plane
		var local_x = randf_range(mesh_aabb.position.x, mesh_aabb.position.x + mesh_aabb.size.x)
		var local_z = randf_range(mesh_aabb.position.z, mesh_aabb.position.z + mesh_aabb.size.z)
		


		# Convert to world coordinates
		var world_pos = walk_plane.to_global(Vector3(local_x, 0, local_z))
		world_pos.y = tile.terrain.get_height(world_pos.x, world_pos.z, island_x, island_y) 
		world_pos.y += 0.2
		# Teleport player
		
		player_node.move_to_position(player_node.global_position, world_pos, get_standar_duration())
		#player_node.global_position = world_pos
		
		print("moving player to: ", str(key2))
		
	

# Index	Name
# 0	Nourriture
# 1	Linemate
# 2	Deraumère
# 3	Sibur
# 4	Mendiane
# 5	Phiras
# 6	Thystame

func create_islands(position, x, y):
	var instance = island.instantiate()
	
	instance.position = position
	instance.index = tiles.size()
	var key = str(x, ", ", y)
	tile_dic[key] = tiles.size()
	
	add_child(instance)
	tiles.append(instance)
	instance.terrain.generate_terrain(x, y, island_x, island_y)
	instance.x = x
	instance.y = y
	instance.width = island_x
	instance.height = island_y
	instance.label.text = str("[",x ,", ", y,"]")
	SignalBus.new_island.emit(x, y)


func msz(x, y):
	print("TilesX:", x, "TilesY:", y)
	island_x = x
	island_y = y
	var	i = 0
	var j = 0

	i = 0
	while i < island_x:
		j = 0
		while j < island_y:
			var pos = Vector3(i * 5, 0, j * 5)
			
			create_islands(pos, i , j)
			if i == (island_x / 2) and j == (island_y / 2):
				SignalBus.player_start.emit(pos)
			SignalBus.load_bar.emit(((i * island_y) + j + 1) / (island_x * island_y) * 100)
			j += 1
		i += 1
	SignalBus.remove_load_screen.emit()


# 🧍 `pnw #n X Y O L N` — Player Info
# Player ID 1 is at tile (3,4), facing **East** (O=2), level 1, from team "TeamRocket".
func pnw(n, x, y, direction, level, team: String):
	
	if not players_list.has(n):
		var instance = player.instantiate()

		# Generate random number between 1 and 6 (inclusive)
		var random_index = randi_range(1, 6)
		var profile_path = "res://Assets/Textures/character0%d.png" % random_index
		var profile_texture = load(profile_path) as Texture2D

		# Set position and properties
		add_child(instance)
		players.append(instance)

		instance.Character.id = n
		instance.Character.level = level
		instance.Character.texture = profile_texture  # Assuming `texture` is used for rendering
		instance.Character.team = team
		if teams_dic.has(team):
			instance.Character.color = teams_dic[team]
			instance.change_body_color(teams_dic[team])
		
		instance.rotate_orientation(int(direction))
		

		
		
		
		players_list[n] = instance
		move_player(n, x, y)
		SignalBus.new_player.emit(n, team)






# `pbc #n M`
func pbc(number, message):
	var stri: String = message

	SignalBus.new_message.emit(str("Player n", number, ": ", message))

var used_hues: Array = []

func get_distinct_color() -> Color:
	var step = 1.0 / max(1, (used_hues.size() + 1))
	var h = fmod(used_hues.size() * step, 1.0) # evenly spread hues
	used_hues.append(h)
	return Color.from_hsv(h, 0.8, 0.9)


func tna(team: String):
	if (teams.find(team) == -1):
		teams.append(team)
		#todo
		teams_dic[team] = get_distinct_color()


# 🥚 `enw #e #n X Y` — Egg
#Sent once per existing egg:
# enw 5 1 2 3
#**Means:** Egg ID `5` was laid by player `1` at tile (2,3).
func enw(id, father, x, y):
	var instance = egg.instantiate()

	add_child(instance)




# `pin #n X Y q0 q1 q2 q3 q4 q5 q6`

#> Player inventory has changed.
# **Example:**
# pin 1 2 2 3 0 0 0 0 1 0
# → Player 1 is at (2,2) and now holds:
# * 3 food
# * 1 Phiras
func pin(id, x, y, Nourriture, Linemate, Deraumere, Sibur, Mendiane, Phiras, Thystame):
	if (players_list.has(id)):
		var char: Characters = players_list[id].Character
		
	
		# this will tp the character
		move_player(id, x, y)
		
		
		print(str("Player: ", id, "Nourriture: ", Nourriture, " ,Linemate: ", Linemate, " ,Deraumere: ", Deraumere, " ,Sibur: ", Sibur, " ,Mendiane: ", Mendiane))
		char.inventory.food = int(Nourriture)
		char.inventory.linemate = int(Linemate)
		char.inventory.deraumere = int(Deraumere)
		char.inventory.sibur = int(Sibur)
		char.inventory.mendiane = int(Mendiane)
		char.inventory.phiras = int(Phiras)
		char.inventory.thystame = int(Thystame)


### 🧍 **Player Events**
#### `ppo #n X Y O`
#> Player has moved or turned.
#**Example:**
#ppo 1 3 5 2

func ppo(id, x, y, orientation):
	if (players_list.has(id)):
		var char: Characters = players_list[id].Character
		
		# this will tp the character
		char.orientation = orientation
		players_list[id].rotate_orientation(int(orientation))
		move_player(id, x, y)
		
func plv(id, level):
	if (players_list.has(id)):
		var char: Characters = players_list[id].Character
		
		# this will tp the character
		char.level = int(level)


# 🔮 **Incantations (Level Up Rituals)**
# `pic X Y L #n #n ...`
#> Incantation started on tile (X, Y) at level L by players.
# **Example:**
# pic 2 2 2 1 3 4
# → An incantation is starting at (2,2) for level 2, involving players 1, 3, and 4.
func pic(split: PackedStringArray):
	var x = int(split[1])
	var y = int(split[2])
	var l = int(split[3])
	
	print("Incantation started at level:", l)
	
	var i: int = 4
	while  i < split.size():
		SignalBus.start_player_incatation.emit(int(split[i]))
		i += 1
		
	var key2 = str(x, ", ", y)
	var tile: Node3D = tiles[tile_dic[key2]]
	tile.start_incantation()

func pie(split: PackedStringArray):
	print("piee!!!!!!!!!!!!!!!!!!!!!!!")
	var x = int(split[1])
	var y = int(split[2])

	var key2 = str(x, ", ", y)
	var tile: Node3D = tiles[tile_dic[key2]]
	tile.stop_incantation()
	SignalBus.stop_enchantation.emit()


func parse_command(command):
	var	split = command.split(" ")
	
	var test: String = "hola"
	test.split()

	match split[0]:
		"msz":
			if split.size() == 3:
				msz(int(split[1]), int(split[2]))
			else:
				print("Error: msz command: wrong number of arguments: ", command)
		"pnw":
			if split.size() == 7:
				pnw(split[1], split[2], split[3], split[4], split[5], split[6])
			else:
				print("Error: pnw command: wrong number of arguments: ", command)
		"tna":
			if split.size() == 2:
				tna(str(split[1]))
		"bct":
			if split.size() == 10:
				var x = str(split[1]).to_int()
				var y = str(split[2]).to_int()
				var key2 = str(x, ", ", y)
				var tile: Node3D = tiles[tile_dic[key2]]
				tile.bct(split[3], split[4], split[5], split[6], split[7], split[8], split[9])
			else:
				print("Error: bct command: wrong number of arguments: ", command)
		"pin":
			if split.size() == 11:
				print(str("Pin: ", split))
				pin(split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8], split[9], split[10])
			else:
				print("Error: pin command: wrong number of arguments: ", command)
		"ppo":
			if split.size() == 5:
				ppo(split[1], split[2], split[3], split[4])
			else:
				print("Error: ppo command: wrong number of arguments: ", command)
		"plv":
			if split.size() == 3:
				plv(split[1], split[2])
			else:
				print("Error: plv command: wrong number of arguments: ", command)
				
				
				
		"pex":
			print(split[0])
		"pgt":
			print(split[0])
		"pdr":
			print(split[0])
			
			
			
		"pbc":
			pbc(split[1], split[2])
		"pdi":
			print(split[0])
			
			
			
		"pic":
			pic(split)
		"pie":
			pie(split)
			
			
		"pfk":
			print(split[0])
		"enw":
			if split.size() == 5:
				enw(split[1], split[2], split[3], split[4])
			else:
				print("Error: enw command: wrong number of arguments: ", command)
		"eht":
			print(split[0])
		"ebo":
			print(split[0])
		"edi":
			print(split[0])
		"sgt":
			if split.size() == 2:
				time = int(split[1])
		"sst":
			print(split[0])
		"seg":
			print(split[0])
		"smg":
			print(split[0])
		"suc":
			print(split[0])
		"sbp":
			print(split[0])
		"":
			return
		"BIENVENUE":
			return#print("ignore this...")
		_:
			print("wtf is this...", split[0])
	

func parse_message(message):
	var commands = message.split("\n")
	for command in commands.size():
		parse_command(commands[command])
	print("size of the array:", commands.size())


func return_menu():
	SignalBus.SceneLoaded = false


func _ready():
	SignalBus.command.connect(parse_message)
	SignalBus.SceneLoaded = true
	print("SceneLoaded!!!!")
