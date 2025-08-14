extends Control

@onready var	gameMannager = $"../../../GameManager"
@onready var	Linemate = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Linemate
@onready var	Mendiane = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Mendiane
@onready var	Phiras = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Phiras
@onready var	Sibur = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Sibur
@onready var	Tystame = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Tystame
@onready var	Deraumer = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/GridContainer/Deraumere
@onready var	Food = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Food
@onready var	Name: RichTextLabel = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer3/PanelContainer/PlayerName
@onready var	Level: RichTextLabel =$PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/Panel/HBoxContainer2/VBoxContainer2/LevelPlayer
@onready var	Team: RichTextLabel = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/Panel/HBoxContainer2/VBoxContainer2/TeamPlayer
@onready var	Health: ProgressBar = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer3/Health
@onready var	texture: TextureRect = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer/Control/ProfilePicture
@onready var	color: ColorRect = $PlayerPanel/HBoxContainer4/VBoxContainer/VBoxContainer/HBoxContainer/Control/ColorRect


var playerSelected

func lock_player(player):
	SignalBus.lock_player.emit(player.object)

func show_by_id(id):
	var player: Characters = gameMannager.players_list[str(id)].Character
	show_player(player)
	lock_player(player)
	
func show_by_sort(number):
	var player: Characters = gameMannager.players[number].Character
	show_player(player)
	lock_player(player)
	
func update_player_viewer():
	if visible:
		show_player(playerSelected)

func show_player(player):
	playerSelected = player
	visible = true
	
	Level.text = str(player.level)
	Team.text = str(player.team)
	Name.text = str("Player ", player.id)
	
	
	Linemate.updateItem(player.inventory.linemate)
	Mendiane.updateItem(player.inventory.mendiane)
	Phiras.updateItem(player.inventory.phiras)
	Sibur.updateItem(player.inventory.sibur)
	Tystame.updateItem(player.inventory.thystame)
	Deraumer.updateItem(player.inventory.deraumere)
	Food.updateItem(player.inventory.food)
	
	
	texture.texture = player.texture
	color.color = player.color
	
	
func hide_player_viewer(id):
	visible = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.select_player.connect(show_by_sort)
	SignalBus.select_player_by_id.connect(show_by_id)
	
	SignalBus.select_tile.connect(hide_player_viewer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
