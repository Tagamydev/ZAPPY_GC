extends Node

var tcp: StreamPeerTCP
var connected := false
var enable := false
var command_buffer: Array[String] = []
var flush := false

signal connected_to_server
signal disconnected_from_server
signal message_received(msg: String)

func connect_to_server(host: String, port: int):
	tcp = StreamPeerTCP.new()
	var err := tcp.connect_to_host(host, port)
	if err != OK:
		print("Failed to connect: ", err)
	else:
		print("Connecting to %s:%d..." % [host, port])
		enable = true

func _process(delta: float) -> void:
	if enable:
		_poll_network()

func _poll_network():
	tcp.poll()
	match tcp.get_status():
		StreamPeerTCP.STATUS_CONNECTING:
			pass
		StreamPeerTCP.STATUS_CONNECTED:
			if not connected:
				connected = true
				print("Connected to server")
				emit_signal("connected_to_server")
				send_message("GRAPHIC\n")

			var available := tcp.get_available_bytes()
			if available > 0:
				var result := tcp.get_data(available)
				if result[0] == OK:
					var msg = result[1].get_string_from_utf8()
					print(msg)
					if flush:
						emit_signal("message_received", msg)
					else:
						command_buffer.append(msg)
				else:
					_handle_error("Read error: %d" % result[0])
		StreamPeerTCP.STATUS_ERROR:
			_handle_error("Connection error")
		StreamPeerTCP.STATUS_NONE:
			pass

func flush_messages():
	flush = true
	for msg in command_buffer:
		emit_signal("message_received", msg)
	command_buffer.clear()

func send_message(msg: String):
	if tcp and tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		tcp.put_data(msg.to_utf8_buffer())

func _handle_error(msg: String):
	print(msg)
	emit_signal("disconnected_from_server")
	enable = false
	connected = false
	tcp = null
	command_buffer.clear()
	flush = false
