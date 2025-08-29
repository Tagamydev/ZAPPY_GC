extends Node3D

var	Island : Tiles = Tiles.new()
var portal = preload("res://Prefabs/portal.tscn")
var Deraumere = preload("res://Prefabs/Items/Deraumere.tscn")
var Linemate = preload("res://Prefabs/Items/Linemate.tscn")
var Mendiane = preload("res://Prefabs/Items/Mendiane.tscn")
var Phiras = preload("res://Prefabs/Items/Phiras.tscn")
var Sibur = preload("res://Prefabs/Items/Sibur.tscn")
var Tystame = preload("res://Prefabs/Items/Tystame.tscn")
var food = preload("res://Prefabs/Items/Food.tscn")

var Deraumere_l: Array = []
var Linemate_l: Array = [] 
var Mendiane_l: Array = []
var Phiras_l: Array = []
var Sibur_l: Array = []
var Tystame_l: Array = []
var food_l: Array = []

var x = 0
var y = 0
var width = 0
var height = 0

var terrain_heigth = 0

@onready var label: Label3D = $Label3D
@onready var walk_plane = $walkPlane
@onready var terrain = $Terrain

var snow_tree = preload("res://Prefabs/Trees/Snow_Tree.tscn")
var standar_tree = preload("res://Prefabs/Trees/Standar_Tree.tscn")
var palm_tree = preload("res://Prefabs/Trees/Palm_Tree.tscn")
var sea_tree = preload("res://Prefabs/Trees/Sea_Tree.tscn")

var index = 0

@onready var player: AnimationPlayer = $Incantation/AnimationPlayer

func stop_incantation():
	player.play_backwards("Incantation")

	player.animation_finished.connect(_on_incantation_finished, CONNECT_ONE_SHOT)

func _on_incantation_finished(anim_name: String) -> void:
	if anim_name == "Incantation":
		player.play("RESET")

func start_incantation():
	player.play("Incantation")



func spawn_trees():
	var i = 0
	var total = 0
	var item = snow_tree

	if (terrain_heigth < 0):
		total = int(randf_range(0, 10))
		item = sea_tree
	elif (terrain_heigth < 1):
		total = int(randf_range(0, 2))
		item = palm_tree
	elif (terrain_heigth < 4):
		total = int(randf_range(2, 10))
		item = standar_tree
	else:
		total = int(randf_range(0, 2))
		item = snow_tree
	
	while (i < total):
		spawn_item(item)
		i += 1


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
	world_pos.y = terrain.get_height(world_pos.x, world_pos.z, width, height) 
	
	add_child(block)
	block.global_position = world_pos
	block.global_rotation.y = randf_range(0, 360)
	block.global_rotation.x = randf_range(-0.25, 0.25)
	block.global_rotation.z = randf_range(-0.25, 0.25)
	var random_scale = randf_range(0.8, 1.5)
	block.scale = Vector3(random_scale, random_scale, random_scale)
	return block

var item_map = {
	"food": {
		"prop": "food",
		"list": food_l,
		"scene": food
	},
	"linemate": {
		"prop": "linemate",
		"list": Linemate_l,
		"scene": Linemate
	},
	"deraumere": {
		"prop": "deraumere",
		"list": Deraumere_l,
		"scene": Deraumere
	},
	"sibur": {
		"prop": "sibur",
		"list": Sibur_l,
		"scene": Sibur
	},
	"mendiane": {
		"prop": "mendiane",
		"list": Mendiane_l,
		"scene": Mendiane
	},
	"phiras": {
		"prop": "phiras",
		"list": Phiras_l,
		"scene": Phiras
	},
	"thystame": {
		"prop": "thystame",
		"list": Tystame_l,
		"scene": Tystame
	}
}


func update_item(item: String, n: int) -> void:
	if not item_map.has(item):
		return
	
	var info = item_map[item]
	var prop = info.prop
	var list = info.list
	var scene = info.scene

	var current = Island.get(prop)
	if current == n:
		return
	
	var diff = n - current
	Island.set(prop, n)

	if diff < 0:
		for i in range(abs(diff)):
			if list.size() != 0:
				var instance = list.back()
				if (instance != null):
					instance.queue_free()
				list.erase(instance)
	elif diff > 0:
		for i in range(diff):
			list.append(spawn_item(scene))


func SpawnItem(item, n):
	update_item(item, n)


func bct(food, linemate, deraumere, sibur, mendiane, phiras, thystame):
	SpawnItem("food", str(food).to_int())
	SpawnItem("linemate", str(linemate).to_int())
	SpawnItem("deraumere", str(deraumere).to_int())
	SpawnItem("sibur", str(sibur).to_int())
	SpawnItem("mendiane", str(mendiane).to_int())
	SpawnItem("phiras", str(phiras).to_int())
	SpawnItem("thystame", str(thystame).to_int())
