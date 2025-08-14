extends Node3D

var Character : Characters = Characters.new()

@onready var model = $Model

func _ready():
	Character.object = self
	print("I'm alive mtf")


func rotate_orientation(o: int):
	var yaw = 0

	match o:
		1:  # North
			yaw = 180
		2:  # East
			yaw = 90
		3:  # South
			yaw = 0
		4:  # West
			yaw = -90
		_:
			yaw = 0  # default if invalid

	# Rotate model only on Y axis
	model.rotation_degrees = Vector3(
		model.rotation_degrees.x,
		yaw,
		model.rotation_degrees.z
	)
