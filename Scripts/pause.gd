extends Control


func hide1():
	visible = false

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			visible = !visible


func _ready():
	SignalBus.hide_menu.connect(hide1)
