extends Button


@onready var Port = $"../Port"
@onready var Host = $"../Host"

var portNumber = "4242"
var hostString = "127.0.0.1"


func _on_pressed() -> void:
	SignalBus.hide_menu.emit()
	if Port.text != "":
		portNumber = Port.text
	if Host.text != "":
		hostString = Host.text
	SignalBus.new_connection.emit(hostString, portNumber)
	pass
