extends RichTextLabel

@onready var recon_button = $"../Button2"

func server_down():
	text = "[color=red]offline[/color]"
	recon_button.disabled = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_enabled = true
	SignalBus.server_down.connect(server_down)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
