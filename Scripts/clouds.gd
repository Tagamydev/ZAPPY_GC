extends MeshInstance3D

@export var speed: float = 0.5   # movement speed
@export var direction: Vector3 = Vector3(1, 0, 0) # initial drift direction
@export var limit: float = 100.0 # max distance from origin

var start_pos: Vector3

func _ready():
	start_pos = transform.origin

func _process(delta: float) -> void:
	# Move cloud
	translate(direction.normalized() * speed * delta)

	# Check bounds (X and Z separately for rectangular area)
	var offset = transform.origin - start_pos

	if abs(offset.x) > limit:
		direction.x *= -1  # flip horizontally
	if abs(offset.z) > limit:
		direction.z *= -1  # flip vertically
