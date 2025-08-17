extends StaticBody3D


@onready var island = $"../.."
@onready var selection = $"../../Selection"


func objectPressed():
	SignalBus.select_tile.emit(island.x * island.width + island.y)
	
	
func select_island(n):
	if island.x * island.width + island.y == n:
		selection.visible = true
	else:
		selection.visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_tile.connect(select_island)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
