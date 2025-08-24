extends TextureProgressBar


@onready var player: AnimationPlayer = $"../AnimationPlayer"


func remove_load_screen():
	player.play("HideLoadScreen")

func update_value(number):
	value = number

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.load_bar.connect(update_value)
	SignalBus.remove_load_screen.connect(remove_load_screen)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
