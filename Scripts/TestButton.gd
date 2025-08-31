extends Button


@onready var hola = $".."


func _on_pressed():
	hola.connect_to_server("127.0.0.1", 4242)
	
