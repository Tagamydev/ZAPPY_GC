extends ColorRect

func enable_crt():
	visible = true

func disable_crt():
	visible = false
	
func _ready() -> void:
	SignalBus.enable_crt.connect(enable_crt)
	SignalBus.disable_crt.connect(disable_crt)
