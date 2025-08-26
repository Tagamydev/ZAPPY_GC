extends CheckBox


# Called when the node enters the scene tree for the first time.
func _ready():
	button_pressed = bool(SignalBus.MusicEnabled)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(toggled_on):
	SignalBus.MusicEnabled = toggled_on
	SignalBus.update_music.emit()
	pass # Replace with function body.
