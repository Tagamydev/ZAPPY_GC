extends PanelContainer

@onready var texture: TextureRect = $TextureRect
@onready var quantity: RichTextLabel = $RichTextLabel
# Called when the node enters the scene tree for the first time.

func updateItem(number):
	print(str("here is the number: ", number))
	quantity.text = str(number)
	if (number != 0):
		texture.modulate = Color(1, 1, 1, 1)
	else:
		texture.modulate = Color(0.25, 0.25, 0.25, 1)


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
