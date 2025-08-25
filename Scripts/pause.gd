extends Control

@onready var mainMenu: Control = $MainMenu

func hide1():
	visible = false
	mainMenu.process_mode = Node.PROCESS_MODE_DISABLED


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			visible = !visible


func _ready():
	visible = false
	SignalBus.hide_menu.connect(hide1)
