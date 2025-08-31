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

var egg_list: Dictionary = {}

var tiles: Array = []
var tile_dic: Dictionary = {}

var players_in_tiles: Dictionary = {}

var teams: Array = []
var teams_dic: Dictionary = {}
var time = 100


func get_standar_duration():
	return float(7.0 * 1.0 / float(time))


func player_movement(id, x, y, final_pos: Vector3):
	x = int(x)
	y = int(y)
	var char: Characters = players_list[id].Character
	var key = str(char.x, ", ", char.y)
	var key2 = str(x, ", ", y)
	var player_node = players_list[id]
	var tile: Node3D = tiles[tile_dic[key2]]
	
	player_node.Character.x = int(x)
	player_node.Character.y = int(y)
	
	final_pos.y = tile.terrain.get_height(final_pos.x, final_pos.z, island_x, island_y) 
	final_pos.y += 0.2

	player_node.move_to_position(player_node.global_position, final_pos, get_standar_duration())


func update_player_in_tiles(id, x, y):
	if players_list.has(id):
		x = int(x)
		y = int(y)
		var char: Characters = players_list[id].Character
		
		if not (char.x == x and char.y == y):
			var key = str(char.x, ", ", char.y)
			var key2 = str(x, ", ", y)

			if players_in_tiles.has(key):
				players_in_tiles[key].erase(id)
			
			if not players_in_tiles.has(key2):
				players_in_tiles[key2] = []
				
			players_in_tiles[key2].append(id)


func move_player_to_item(id, x, y, item):
	if players_list.has(id):
		x = int(x)
		y = int(y)
		update_player_in_tiles(id, x, y)
		var char: Characters = players_list[id].Character
		var key = str(char.x, ", ", char.y)
		var key2 = str(x, ", ", y)
		var player_node = players_list[id]
		var tile: Node3D = tiles[tile_dic[key2]]
		
		var item_pos = tile.get_item_pos(item)
		player_movement(id, x, y, item_pos)

func move_player_random(id, x, y):
	if players_list.has(id):
		x = int(x)
		y = int(y)
		update_player_in_tiles(id, x, y)

		# make random movement
		var char: Characters = players_list[id].Character
		var key = str(char.x, ", ", char.y)
		var key2 = str(x, ", ", y)
		var player_node = players_list[id]
		var tile: Node3D = tiles[tile_dic[key2]]
		var walk_plane = tile.get_node("walkPlane") as MeshInstance3D
		var mesh_aabb = walk_plane.get_mesh().get_aabb()
		var local_x = randf_range(mesh_aabb.position.x, mesh_aabb.position.x + mesh_aabb.size.x)
		var local_z = randf_range(mesh_aabb.position.z, mesh_aabb.position.z + mesh_aabb.size.z)
		var world_pos = walk_plane.to_global(Vector3(local_x, 0, local_z))

		player_movement(id, x, y, world_pos)


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
	instance.spawn_trees()
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
		var skin_color = 0

		if random_index == 5:
			skin_color = Color(18.0 / 255.0, 76.0 / 255.0, 51.0 / 255.0)
		else:
			skin_color = Color(255.0 /255.0, 174.0 / 255.0, 148.0 / 255.0)
		# Set position and properties
		add_child(instance)
		players.append(instance)

		instance.Character.id = n
		instance.Character.level = level
		instance.Character.texture = profile_texture  # Assuming `texture` is used for rendering
		instance.Character.team = team
		if teams_dic.has(team):
			instance.Character.color = teams_dic[team]
			instance.set_colors(skin_color, teams_dic[team])
		
		instance.rotate_orientation(int(direction))
		

		players_list[n] = instance
		move_player_random(n, x, y)
		SignalBus.new_player.emit(n, team)




var lyrics_it = 0
var ado = []
# `pbc #n M`
func pbc(number, message):
	var stri: String = message
	var rand = randf_range(0.0, 1)
	if SignalBus.MusicEnabled:
		players_list[number].speak(time + rand)
	message = ado[lyrics_it]
	SignalBus.new_message.emit(str("[color=",players_list[number].Character.color.to_html(),"]Player n", number, ":[/color] ", message))
	if (lyrics_it == (ado.size() - 1)):
		lyrics_it = 0
	else:
		lyrics_it += 1

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
	x = str(x).to_int()
	y = str(y).to_int()
	var key2 = str(x, ", ", y)
	var tile: Node3D = tiles[tile_dic[key2]]

	egg_list[int(id)] = tile.spawn_item(egg)
	
	print("DANnew egg: ", id)
	
	
	
func eht(id):
	if egg_list.has(int(id)):
		egg_list[int(id)].hatch()
	else:
		print("DANGEEEEEEEEEEEEERRRRRRRRRRRR, ", egg_list, "id to match: ", id)
	
	
func ebo(id):
	if egg_list.has(int(id)):
		egg_list[int(id)].crack_egg()
	else:
		print("DANGEEEEEEEEEEEEERRRRRRRRRRRR, ", egg_list, "id to match: ", id)
	
	
func edi(id):
	if egg_list.has(int(id)):
		egg_list[int(id)].queue_free()
		egg_list.erase(int(id))
	else:
		print("DANGEEEEEEEEEEEEERRRRRRRRRRRR, ", egg_list, "id to match: ", id)


func pfk(player):
	'''
	if players_list.has(player):
		var char: Characters = players_list[player].Character
		
		var x = char.x
		var y = char.y
		var number = int(egg_list.keys()[-1]) + 1
		enw(number, player, x, y)
	'''

# `pin #n X Y q0 q1 q2 q3 q4 q5 q6`
#> Player inventory has changed.
# **Example:**
# pin 1 2 2 3 0 0 0 0 1 0
# → Player 1 is at (2,2) and now holds:
# * 3 food
# * 1 Phiras
func pin(id, x, y, Nourriture, Linemate, Deraumere, Sibur, Mendiane, Phiras, Thystame):
	if (players_list.has(id)):
		x = int(x)
		y = int(y)
		var char: Characters = players_list[id].Character

		if not (char.x == x and char.y == y):
			move_player_random(id, x, y)

		print(str("Player: ", id, "Nourriture: ", Nourriture, " ,Linemate: ", Linemate, " ,Deraumere: ", Deraumere, " ,Sibur: ", Sibur, " ,Mendiane: ", Mendiane))
		char.inventory.food = int(Nourriture)
		char.inventory.linemate = int(Linemate)
		char.inventory.deraumere = int(Deraumere)
		char.inventory.sibur = int(Sibur)
		char.inventory.mendiane = int(Mendiane)
		char.inventory.phiras = int(Phiras)
		char.inventory.thystame = int(Thystame)
		SignalBus.update_player_viewer.emit()


### 🧍 **Player Events**
#### `ppo #n X Y O`
#> Player has moved or turned.
#**Example:**
#ppo 1 3 5 2

func ppo(id, x, y, orientation):
	if (players_list.has(id)):
		x = int(x)
		y = int(y)
		var char: Characters = players_list[id].Character
		
		# this will tp the character
		char.orientation = orientation
		players_list[id].rotate_orientation(int(orientation))
		if not (char.x == x and char.y == y):
			move_player_random(id, x, y)


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
	var x = int(split[1])
	var y = int(split[2])

	var key2 = str(x, ", ", y)
	var tile: Node3D = tiles[tile_dic[key2]]
	tile.stop_incantation()
	SignalBus.stop_enchantation.emit()


func pdi(number):
	players_list[number].death()
	SignalBus.update_player_viewer.emit()


func pgt(player, item):
	item = int(item)
	var char: Characters = players_list[player].Character
	var x = char.x
	var y = char.y
	match item:
		0:
			move_player_to_item(player, x, y, "food")
		1:
			move_player_to_item(player, x, y, "linemate")
		2:
			move_player_to_item(player, x, y, "deraumere")
		3:
			move_player_to_item(player, x, y, "sibur")
		4:
			move_player_to_item(player, x, y, "mendiane")
		5:
			move_player_to_item(player, x, y, "phiras")
		6:
			move_player_to_item(player, x, y, "thystame")


func smg(message):
	SignalBus.new_message.emit(str("[color=red]Server:[/color] ", message))


func seg(team):
	SignalBus.new_message.emit(str("[color=green]the team: ", team, " has win!!![/color]"))


		
	
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
			pgt(split[1], split[2])
		"pdr":
			print(split[0])
			
		"pbc":
			pbc(split[1], split[2])
		"pdi":
			pdi(split[1])
			
		"pic":
			pic(split)
		"pie":
			pie(split)
			
			
		"pfk":
			pfk(split[1])
		"enw":
			if split.size() == 5:
				enw(split[1], split[2], split[3], split[4])
			else:
				print("Error: enw command: wrong number of arguments: ", command)
		"eht":
			eht(split[1])
		"ebo":
			ebo(split[1])
		"edi":
			edi(split[1])
			

		"sgt":
			if split.size() == 2:
				time = int(split[1])
		"sst":
			if split.size() == 2:
				time = int(split[1])
		"seg":
			seg(split[1])
		"smg":
			smg(split[1])
		"suc":
			print(split[0])
		"sbp":
			print(split[0])
		"":
			return
		"BIENVENUE":
			return#print("ignore this...")
		_:
			print("Unknown command: ", split[0])
	

func parse_message(message):
	var commands = message.split("\n")
	for command in commands.size():
		parse_command(commands[command])


func return_menu():
	SignalBus.SceneLoaded = false



var lyrics = "Dies iræ, dies illa
Solvet sæclum in favilla
Teste David cum Sibylla
Quantus tremor est futurus
Quando iudex est venturus
Cuncta stricte discussurus
Dies iræ, dies illa
Solvet sæclum in favilla
Teste David cum Sibylla
Quantus tremor est futurus
Quando iudex est venturus
Cuncta stricte discussurus
Quantus tremor est futurus
Dies iræ, dies illa
Quantus tremor est futurus
Dies iræ, dies illa
Quantus tremor est futurus
Quantus tremor est futurus
Quando iudex est venturus
Cuncta stricte discussurus
Cuncta stricte (cuncta stricte)
Stricte discussurus
Cuncta stricte (cuncta stricte)
Stricte discussurus"

func _ready():
	SignalBus.command.connect(parse_message)
	SignalBus.SceneLoaded = true
	ado = lyrics.split("\n")
	print("SceneLoaded!!!!")
