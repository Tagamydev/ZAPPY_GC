extends ColorRect

@onready var player: CharacterBody3D = $"../CharacterBody3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.global_position.y < -1.4:
		visible = true
	else:
		visible = false
	pass
