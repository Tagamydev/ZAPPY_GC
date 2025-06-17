extends Node3D


var island = preload("res://Prefabs/island.tscn")
var	island_x : int = 10
var island_y : int = 11
var island_total_x = 0
var island_total_y = 0



func create_islands(position):
	var instance = island.instantiate()
	instance.position = position
	add_child(instance)

func _ready():
	var	i = 0
	var j = 0
	
	i = 0
	while i < island_x:
		j = 0
		while j < island_y:
			create_islands(Vector3(i * 10, 0, j * 10))
			j += 1
		i += 1
