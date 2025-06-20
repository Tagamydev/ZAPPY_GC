extends RichTextLabel

func new_message(message):
	append_text("la mama de la mama")

func _ready():
	SignalBus.new_message.connect(new_message)
