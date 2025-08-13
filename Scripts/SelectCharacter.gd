extends StaticBody3D


@onready var arrow = $"../../Model/Arrow"
@onready var Character = $"../.."


func selected(n):
	if (Character.Character.id == n):
		arrow.visible = true
	else:
		arrow.visible = false


func objectPressed():
	SignalBus.select_player_by_id.emit(Character.Character.id)
	print(name)

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_player_by_id.connect(selected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
