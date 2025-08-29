extends Control

@onready var ContentBox = $"../Control"
@onready var Chat = $"../Control/HBoxContainer/Chat"
@onready var Items = $"../Control/HBoxContainer/Control"
@onready var toggle_button = $Button3

func	chat_button_pressed():
	ContentBox.visible = false
	Chat.visible = true
	Items.visible = false
	hide_toggle_pressed()
	
func	items_button_pressed():
	ContentBox.visible = false
	Chat.visible = false
	Items.visible = true
	hide_toggle_pressed()

func	hide_toggle_pressed():
	if ContentBox.visible:
		ContentBox.visible = false
		toggle_button.text = "^"
	else:
		ContentBox.visible = true
		toggle_button.text = "v"
		
