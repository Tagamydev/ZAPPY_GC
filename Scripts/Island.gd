extends Node3D

var	Island : Tiles = Tiles.new()
var portal = preload("res://Prefabs/portal.tscn")
var Deraumere = preload("res://Prefabs/Items/Deraumere.tscn")
var Linemate = preload("res://Prefabs/Items/Linemate.tscn")
var Mendiane = preload("res://Prefabs/Items/Mendiane.tscn")
var Phiras = preload("res://Prefabs/Items/Phiras.tscn")
var Sibur = preload("res://Prefabs/Items/Sibur.tscn")
var Tystame = preload("res://Prefabs/Items/Tystame.tscn")

var Deraumere_l: Array = []
var Linemate_l: Array = [] 
var Mendiane_l: Array = []
var Phiras_l: Array = []
var Sibur_l: Array = []
var Tystame_l: Array = []
var food_l: Array = []

@onready var walk_plane = $walkPlane
@onready var terrain = $Terrain

func create_portal():
	var instance = portal.instantiate()
	
	add_child(instance)
	instance.play_portal_animation()


func spawn_item(item):
	var block = item.instantiate()

	var mesh_aabb = walk_plane.get_mesh().get_aabb()
	var local_x = randf_range(mesh_aabb.position.x, mesh_aabb.position.x + mesh_aabb.size.x)
	var local_z = randf_range(mesh_aabb.position.z, mesh_aabb.position.z + mesh_aabb.size.z)
	var world_pos = walk_plane.to_global(Vector3(local_x, 0, local_z))
	
	add_child(block)
	block.global_position = world_pos
	return block


func SpawnItem(item, n):
	match item:
		"food":
			if Island.food != n:
				var diff = n - Island.food
				Island.food = Island.food + (n - Island.food)
				
				var i = 0
				if diff < 0:
					while (i != n):
						food_l.erase(food_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						food_l.append(spawn_item(Sibur))
						i += 1
		"linemate":
			if Island.linemate != n:
				var diff = n - Island.linemate
				Island.linemate = Island.linemate + (n - Island.linemate)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Linemate_l.erase(Linemate_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Linemate_l.append(spawn_item(Linemate))
						i += 1
		"deraumere":
			if Island.deraumere != n:
				var diff = n - Island.deraumere
				Island.deraumere = Island.deraumere + (n - Island.deraumere)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Deraumere_l.erase(Deraumere_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Deraumere_l.append(spawn_item(Deraumere))
						i += 1
		"sibur":
			if Island.sibur != n:
				var diff = n - Island.sibur
				Island.sibur = Island.sibur + (n - Island.sibur)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Sibur_l.erase(Sibur_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Sibur_l.append(spawn_item(Sibur))
						i += 1
		"mendiane":
			if Island.mendiane != n:
				var diff = n - Island.mendiane
				Island.mendiane = Island.mendiane + (n - Island.mendiane)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Mendiane_l.erase(Mendiane_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Mendiane_l.append(spawn_item(Mendiane))
						i += 1
		"phiras":
			if Island.phiras != n:
				var diff = n - Island.phiras
				Island.phiras = Island.phiras + (n - Island.phiras)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Phiras_l.erase(Phiras_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Phiras_l.append(spawn_item(Phiras))
						i += 1
		"thystame":
			if Island.thystame != n:
				var diff = n - Island.thystame
				Island.thystame = Island.thystame + (n - Island.thystame)
				
				var i = 0
				if diff < 0:
					while (i != n):
						Tystame_l.erase(Tystame_l.back())
						i += 1
				elif diff > 0:
					while (i != n):
						Tystame_l.append(spawn_item(Tystame))
						i += 1


func bct(food, linemate, deraumere, sibur, mendiane, phiras, thystame):
	SpawnItem("food", str(food).to_int())
	SpawnItem("linemate", str(linemate).to_int())
	SpawnItem("deraumere", str(deraumere).to_int())
	SpawnItem("sibur", str(sibur).to_int())
	SpawnItem("mendiane", str(mendiane).to_int())
	SpawnItem("phiras", str(phiras).to_int())
	SpawnItem("thystame", str(thystame).to_int())
