extends Node

var enable := false

var tcp : StreamPeer = null
var connected := false
var commandBuffer: Array = []
var flush := false

func connection(host, port):
	tcp = null
	tcp = StreamPeerTCP.new()
	
	var err : Error = tcp.connect_to_host(host, int(port))
	if err != OK:
		print("Failed to connect: ", err)
	else:
		print("New conextion started. Connecting...")
	enable = true


func _ready():
	SignalBus.new_connection.connect(connection)


func error(error):
	SignalBus.stop_load_animation.emit(error)
	connected = false
	enable = false
	tcp = null
	print(error)


func listen():
	# Required call!
	tcp.poll()

	match tcp.get_status():
		StreamPeerTCP.STATUS_CONNECTING:
			print("Connecting...")
			
		StreamPeerTCP.STATUS_CONNECTED:
			if not connected:
				connected = true
				print("Connected to server.")
				_send_message("GRAPHIC")
				SignalBus.start_game.emit()

			# Check for incoming data
			var available := tcp.get_available_bytes()
			if available > 0:
				var result = tcp.get_data(available)
				if result[0] == OK:
					var byte_array = result[1]
					var message = byte_array.get_string_from_utf8()
					print("Received in network: ", message)
					if SignalBus.SceneLoaded and flush:
						SignalBus.command.emit(message)
					else:
						commandBuffer.append(message)
						
				else:
					error(str("Error: reading data: ", result[0]))

		StreamPeerTCP.STATUS_ERROR:
			var test = 1
			error(str("Error: server connection timeout"))


		StreamPeerTCP.STATUS_NONE:
			# Not connected
			pass
	

func return_to_menu():
	flush = false
	commandBuffer.clear()


func _process(delta):
	if (enable):
		if SignalBus.SceneLoaded and not flush:
			print("Network: Scene loaded!!")
			for command in commandBuffer.size():
				SignalBus.command.emit(commandBuffer[command])
			commandBuffer.clear()
			flush = true
		listen()


func _send_message(message: String):
	if tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		var byte_data := message.to_utf8_buffer()
		tcp.put_data(byte_data)
