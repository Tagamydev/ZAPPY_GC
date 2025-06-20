extends Node

var tcp := StreamPeerTCP.new()
var connected := false

# Set your server IP and port here
const SERVER_IP := "127.0.0.1"
const SERVER_PORT := 4242


func _ready():
	var err := tcp.connect_to_host(SERVER_IP, SERVER_PORT)
	if err != OK:
		print("Failed to connect: ", err)
	else:
		print("Connecting...")

func _process(delta):
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

			# Check for incoming data
			var available := tcp.get_available_bytes()
			if available > 0:
				var result = tcp.get_data(available)
				if result[0] == OK:
					var byte_array = result[1]
					var message = byte_array.get_string_from_utf8()
					print("Received: ", message)
				else:
					print("Error reading data: ", result[0])

		StreamPeerTCP.STATUS_ERROR:
			print("error: server connection timeout")
			connected = false

		StreamPeerTCP.STATUS_NONE:
			# Not connected
			pass

func _send_message(message: String):
	if tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		var byte_data := message.to_utf8_buffer()
		tcp.put_data(byte_data)
		print("Sent: ", message)
