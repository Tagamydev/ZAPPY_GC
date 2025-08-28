extends ColorRect

@onready var player1: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var player2: AudioStreamPlayer = $"../AudioStreamPlayer2"


var is_player1: bool = false

func enable_crt():
	is_player1 = true
	visible = true
	update_music()
	
	
func update_music():
	player1.volume_db = -100
	player2.volume_db = -100
	
	if SignalBus.MusicEnabled:
		if is_player1:
			player1.volume_db = -6
		else:
			player2.volume_db = -6
		

func disable_crt():
	is_player1 = false
	visible = false
	update_music()
	
func _ready() -> void:
	SignalBus.update_music.connect(update_music)
	SignalBus.enable_crt.connect(enable_crt)
	SignalBus.disable_crt.connect(disable_crt)
	disable_crt()
