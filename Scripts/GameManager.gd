extends Node3D


var island = preload("res://Prefabs/island.tscn")
var	island_x : int = 10
var island_y : int = 11
var island_total_x = 0
var island_total_y = 0
var characters: Array[Characters] = []
var tiles: Array[Characters] = []


func create_islands(position):
	var instance = island.instantiate()
	instance.position = position
	add_child(instance)

func parse_command(command):
	var	split = command.split(" ")
	match split[0]:
		"msz":
			print(split[0])
		"pnw":
			print(split[0])
		"tna":
			print(split[0])
		"msz":
			print(split[0])
		"bct":
			print(split[0])
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
			print(split[0])
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
		_:
			print("wtf is this...", split[0])
	

func parse_message(message):
	var commands = message.split("\n")
	for command in commands.size():
		parse_command(commands[command])
	print("size of the array:", commands.size())
	

func _ready():
	
	var	i = 0
	var j = 0
	SignalBus.command.connect(parse_message)
	i = 0
	while i < island_x:
		j = 0
		while j < island_y:
			create_islands(Vector3(i * 10, 0, j * 10))
			j += 1
		i += 1
