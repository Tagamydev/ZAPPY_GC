extends Node3D

var Character : Characters = Characters.new()

@onready var model = $Model
@onready var player : AnimationPlayer = $Model/AnimationPlayer
var first = false
var rot = 1
var enchanted = false

@onready var tomb = $Tomb
@onready var speaker: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var clothes = [
	$Model/Character/Level1,
	$Model/Character/Level2,
	$Model/Character/Level3,
	$Model/Character/Level4,
	$Model/Character/Level5,
	$Model/Character/Level6,
	$Model/Character/Level7,
	$Model/Character/Level8
]

@onready var skin = [
	$Model/Character/Head/WHead,
	$Model/Character/Body/Body,
	$Model/Character/Body/Legs/MeshInstance3D5,
	$Model/Character/Body/Legs/MeshInstance3D6,
	$Model/Character/Body/Legs/MeshInstance3D7
]

@onready var team_col = [
	$Model/Character/Level1/Clothes,
	$Model/Character/Level2/Clothes,
	$Model/Character/Level2/Clothes2,
	$Model/Character/Level3/Clothes,
	$Model/Character/Level4/Clothes,
	$Model/Character/Level5/Clothes,
	$Model/Character/Level6/Clothes,
	$Model/Character/Level6/Clothes2,
	$Model/Character/Level7/Clothes,
	$Model/Character/Level7/Clothes2,
	$Model/Character/Level8/Clothes
]

@onready var body = $Model/Character/Body

func speak(time):
	speaker.play()
	speaker.pitch_scale = 2


func set_clothes(level: int) -> void:
	# If your levels are 1..8:
	var idx: int = clampi(level - 1, 0, clothes.size() - 1)
	# If levels are 0..7, use: var idx := clamp(level, 0, clothes.size() - 1)

	body.visible = (level == 1 or level == 2 or level == 3 or level == 5)

	for n in clothes:
		n.visible = false
	clothes[idx].visible = true

func set_colors(skin_color: Color, team_color: Color) -> void:
	var skin_mat := StandardMaterial3D.new()
	skin_mat.albedo_color = skin_color

	var team_mat := StandardMaterial3D.new()
	team_mat.albedo_color = team_color

	# Apply to all surfaces for each mesh
	for m in skin:
		if m and m.mesh:
			for s in range(m.mesh.get_surface_count()):
				m.set_surface_override_material(s, skin_mat)


	for m in team_col:
		if m and m.mesh:
			for s in range(m.mesh.get_surface_count()):
				m.set_surface_override_material(s, team_mat)
	set_clothes(Character.level)

func update_level():
	var level := int(Character.level) # 1..8 expected here
	set_clothes(level)

func death():
	tomb.visible = true
	model.visible = false
	print("this player is  death:", Character.id)


func change_skin_color(skin_col: Color):
	print("NewSkinColor")
	

func start_enchantation(n):
	if n == Character.id:
		player.play("Incantation")
		enchanted = true

func stop_enchantation():
	if enchanted:
		enchanted = false
		player.play("RESET")
		update_level()


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
