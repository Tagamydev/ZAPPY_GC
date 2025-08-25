extends Button

var turn_off: bool = false

func _on_pressed() -> void:
	turn_off = !turn_off
	
	if turn_off:
		SignalBus.enable_crt.emit()
	else:
		SignalBus.disable_crt.emit()
	pass # Replace with function body.
