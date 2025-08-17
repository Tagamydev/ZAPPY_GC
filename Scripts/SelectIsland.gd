extends StaticBody3D


@onready var island = $"../.."
@onready var selection = $"../../Terrain"


func objectPressed():
	SignalBus.select_tile.emit(island.x * island.width + island.y)
	
func hide_island(n):
	selection.get_surface_override_material(0).emission_enabled = false
	
	
func select_island(n):
	if island.x * island.width + island.y == n:
		selection.get_surface_override_material(0).emission_enabled = true
	else:
		selection.get_surface_override_material(0).emission_enabled = false
		

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_tile.connect(select_island)
	SignalBus.hide_tile_viewer.connect(hide_island)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
