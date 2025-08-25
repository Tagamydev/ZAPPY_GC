extends Node3D

var Character : Characters = Characters.new()

@onready var model = $Model
@onready var player : AnimationPlayer = $Model/AnimationPlayer
var first = false
var rot = 1
var enchanted = false


func start_enchantation(n):
	if n == Character.id:
		player.play("Incantation")
		enchanted = true

func stop_enchantation():
	if enchanted:
		enchanted = false
		player.play("RESET")


func _ready():
	Character.object = self
	SignalBus.start_player_incatation.connect(start_enchantation)
	SignalBus.stop_enchantation.connect(stop_enchantation)


func reset_rot(n):
	rotate_orientation(rot)
	player.stop()
	player.play("RESET")


func move_to_position(start_pos: Vector3, target_pos: Vector3, duration: float) -> void:
	# Set the starting position
	if not first:
		duration = 0
		first = true
	global_position = start_pos


	var parent := model.get_parent() as Node3D
	var from_local := parent.to_local(model.global_transform.origin)
	var to_local   := parent.to_local(target_pos)
	var dir_local  := (to_local - from_local).normalized()

	model.rotation.y = atan2(dir_local.x, dir_local.z)  # radians, local Y only
	
	player.play("walk")

	# Create tween
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)
	tween.set_trans(Tween.TRANS_SINE)     # easing (options: LINEAR, QUAD, SINE, etc.)
	tween.set_ease(Tween.EASE_IN_OUT)     # ease-in-out for smooth start/stop
	tween.step_finished.connect(reset_rot)

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

	rot = o
	# Rotate model only on Y axis
	model.rotation_degrees = Vector3(
		model.rotation_degrees.x,
		yaw,
		model.rotation_degrees.z
	)
