extends StaticBody3D


@onready var arrow = $"../../Model/Arrow"
@onready var Character = $"../.."


func selected(n):
	if (Character.Character.id == n):
		arrow.visible = true
	else:
		arrow.visible = false

func deselected():
	arrow.visible = false
	
func player_lock(player):
	if (player.Character.id == Character.Character.id):
		arrow.visible = true
	else:
		arrow.visible = false


func objectPressed():
	SignalBus.select_player_by_id.emit(Character.Character.id)
	print(name)

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_player_by_id.connect(selected)
	SignalBus.unlock_player.connect(deselected)
	SignalBus.lock_player.connect(player_lock)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
