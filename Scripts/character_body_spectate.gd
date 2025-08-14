extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 2.5
const SENS = 0.001

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

var rotating := false

var playerLocked: Node3D = null
var lock: bool = false

func raycastInteraction():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_dir * 100)
	query.collision_mask = 2
	
	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.collider
		if collider.has_method("objectPressed"):
			collider.call("objectPressed")


func lock_player(player):
	lock = true
	playerLocked = player
	position = player.position

	# Calculate direction from camera to target
	var dir = (player.global_transform.origin - camera.global_transform.origin).normalized()

	# Get yaw (rotation around Y axis)
	var yaw = atan2(dir.x, dir.z)

	# Get pitch (rotation around X axis)
	var pitch = asin(dir.y)

	# Apply to your neck/camera
	neck.rotation.y = yaw + PI
	camera.rotation.x = pitch
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				rotating = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				rotating = false
	
	elif event is InputEventMouseMotion and rotating:
		neck.rotate_y(-event.relative.x * SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_DOWN or event.button_index == MOUSE_BUTTON_WHEEL_UP):
		SPEED += int(event.button_index == MOUSE_BUTTON_WHEEL_UP)
		SPEED -= int(event.button_index == MOUSE_BUTTON_WHEEL_DOWN)
		SPEED = clamp(SPEED, 5, 100)

func _physics_process(delta: float) -> void:
	# Optional gravity (if you want to float freely, disable this)
	# if not is_on_floor():
	#     velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	var direction = (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED) # if using gravity
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("leftclick"):
		raycastInteraction()
	if lock:
		position = playerLocked.position


func unlock():
	lock = false


func _ready():
	SignalBus.unlock_player.connect(unlock)
	SignalBus.lock_player.connect(lock_player)
