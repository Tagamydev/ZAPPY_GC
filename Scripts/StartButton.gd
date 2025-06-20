extends Button


func _on_pressed() -> void:
	SignalBus.new_connection.emit("127.0.0.1", "4242")
	
	pass
