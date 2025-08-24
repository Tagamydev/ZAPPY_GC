extends TextureButton

var playerLock = null
var boolfocus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.lock_player.connect(lock)
	SignalBus.unlock_player.connect(unlock)
	#focus_exited.connect(check_focus)
	pass # Replace with function body.


func	lock(player):
	boolfocus = true
	playerLock = player


func	unlock():
	boolfocus = false

func _on_pressed():
	if boolfocus:
		SignalBus.unlock_player.emit()
		boolfocus = false
	else:
		if playerLock != null:
			SignalBus.lock_player.emit(playerLock)
			boolfocus = true
