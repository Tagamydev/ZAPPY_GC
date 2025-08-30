extends Node3D

@onready var player = $AnimationPlayer
@onready var egg1 = $MeshInstance3D
@onready var egg2 = $Node3D


func hatch():
	egg1.visible = false
	egg2.visible = true


func crack_egg():
	player.play("crack")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
