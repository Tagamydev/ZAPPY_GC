extends Node3D


var island = preload("res://Prefabs/island.tscn")
var player = preload("res://Prefabs/Player.tscn")
var	island_x : int = 10
var island_y : int = 11
var island_total_x = 0
var island_total_y = 0
var players: Array = []
var tiles: Array = []
var time = 100


func create_islands(position, x, y):
	var instance = island.instantiate()
	
	instance.position = position
	add_child(instance)
	tiles.append(instance)
	SignalBus.new_island.emit(x, y)


func msz(x, y):
	island_x = x
	island_y = y
	var	i = 0
	var j = 0

	i = 0
	while i < island_x:
		j = 0
		while j < island_y:
			create_islands(Vector3(i * 10, 0, j * 10), i , j)
			j += 1
		i += 1


func pnw(n, x, y, direction, level, team):
	var instance = player.instantiate()
	
	instance.position = Vector3(1, 2, 1)
	add_child(instance)
	players.append(instance)
	SignalBus.new_player.emit(n, team)


func parse_command(command):
	var	split = command.split(" ")

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
				print("Error: msz command: wrong number of arguments: ", command)
		"tna":
			print(split[0])
		"msz":
			print(split[0])
		"bct":
			if split.size() == 10:
				var tile: Node3D = tiles[(str(split[1]).to_int() * str(split[2]).to_int())]
				tile.bct(split[3], split[4], split[5], split[6], split[7], split[8], split[9])
			else:
				print("Error: msz command: wrong number of arguments: ", command)
		"pin":
			print(split[0])
		"ppo":
			print(split[0])
		"plv":
			print(split[0])
		"pex":
			print(split[0])
		"pgt":
			print(split[0])
		"pdr":
			print(split[0])
		"pbc":
			print(split[0])
		"pdi":
			print(split[0])
		"pic":
			print(split[0])
		"pie":
			print(split[0])
		"pfk":
			print(split[0])
		"enw":
			print(split[0])
		"eht":
			print(split[0])
		"ebo":
			print(split[0])
		"edi":
			print(split[0])
		"sgt":
			if split.size() == 2:
				time = split[1]
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
