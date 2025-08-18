extends RichTextLabel

func new_message(message):
	append_text(str("\n\n" + message))

func _ready():
	text = ""
	SignalBus.new_message.connect(new_message)
