extends MenuButton

var once = false
var i = 0

func new_island(x, y):
	i = i + 1
	get_popup().add_item(str("[", x, "]", "[", y, "]    ", "Island", i))
	
func _ready():
	SignalBus.new_island.connect(new_island)
	
