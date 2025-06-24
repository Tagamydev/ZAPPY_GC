extends AnimatedSprite2D

func start_load(host, port):
	visible = true
	play()


func stop_load(message):
	visible = false
	stop()


func _ready():
	visible = false
	SignalBus.new_connection.connect(start_load)
	SignalBus.stop_load_animation.connect(stop_load)
