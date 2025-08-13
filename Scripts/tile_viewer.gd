extends Control


func show_tile(n):
	visible = true

func hide_tile_viewer(n):
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_tile.connect(show_tile)
	SignalBus.select_player.connect(hide_tile_viewer)
	SignalBus.select_player_by_id.connect(hide_tile_viewer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
