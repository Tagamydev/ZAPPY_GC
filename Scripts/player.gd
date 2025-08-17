extends Node3D

var Character : Characters = Characters.new()

@onready var model = $Model
var first = false

func _ready():
	Character.object = self
	print("I'm alive mtf")



func move_to_position(start_pos: Vector3, target_pos: Vector3, duration: float) -> void:
	# Set the starting position
	if not first:
		duration = 0
		first = true
	global_position = start_pos

	# Create tween
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)
	tween.set_trans(Tween.TRANS_SINE)     # easing (options: LINEAR, QUAD, SINE, etc.)
	tween.set_ease(Tween.EASE_IN_OUT)     # ease-in-out for smooth start/stop


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
