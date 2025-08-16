extends Button

var playerLock = null
var boolfocus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.lock_player.connect(lock)
	SignalBus.unlock_player.connect(unlock)
	#focus_exited.connect(check_focus)
	pass # Replace with function body.

func check_focus():
	if boolfocus:
		grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not has_focus():
		check_focus()
	pass
		

func	lock(player):
	boolfocus = true
	playerLock = player
	grab_focus()


func	unlock():
	release_focus()
	boolfocus = false

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
