extends Button

var playerLock = null
var boolfocus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.lock_player.connect(lock)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func	lock(player):
	boolfocus = true
	playerLock = player
	grab_focus()


func _on_pressed():
	print("hallo")
	if boolfocus:
		release_focus()
		SignalBus.unlock_player.emit()
		boolfocus = false
	else:
		if playerLock != null:
			grab_focus()
			SignalBus.lock_player.emit(playerLock)
			boolfocus = true
