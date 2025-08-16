extends Control


@onready var	gameMannager = $"../../../GameManager"
@onready var	Linemate = $PlayerPanel/VBoxContainer/HBoxContainer4/Linemate
@onready var	Mendiane = $PlayerPanel/VBoxContainer/HBoxContainer4/Mendiane
@onready var	Phiras = $PlayerPanel/VBoxContainer/HBoxContainer4/Phiras
@onready var	Sibur = $PlayerPanel/VBoxContainer/HBoxContainer2/Sibur
@onready var	Tystame = $PlayerPanel/VBoxContainer/HBoxContainer2/Tystame
@onready var	Deraumer = $PlayerPanel/VBoxContainer/HBoxContainer2/Deraumere
@onready var	Food = $PlayerPanel/VBoxContainer/HBoxContainer2/Food
@onready var	Name: RichTextLabel = $PlayerPanel/HBoxContainer3/PanelContainer/TileTitle
@onready var	Players: MenuButton = $PlayerPanel/VBoxContainer/HBoxContainer4/PlayersList

var items: PopupMenu = null

func show_tile(n):
	visible = true
	
	var island: Node3D = gameMannager.tiles[n]
	var key = str(island.x, ", ", island.y)
	
	Name.text = str("Tile X: [", island.x, "], Y: [", island.y, "]")
	
	Linemate.updateItem(island.Linemate_l.size())
	Mendiane.updateItem(island.Mendiane_l.size())
	Phiras.updateItem(island.Phiras_l.size())
	Sibur.updateItem(island.Sibur_l.size())
	Tystame.updateItem(island.Tystame_l.size())
	Deraumer.updateItem(island.Deraumere_l.size())
	Food.updateItem(island.food_l.size())
	
	items.clear()
	
	items.add_item("test1")
	items.add_item("test2")
		
		
	SignalBus.hide_player_viewer.emit()
	SignalBus.unlock_player.emit()

func hide_tile_viewer(n):
	visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	items = Players.get_popup()
	SignalBus.select_tile.connect(show_tile)
	SignalBus.select_player.connect(hide_tile_viewer)
	SignalBus.select_player_by_id.connect(hide_tile_viewer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
