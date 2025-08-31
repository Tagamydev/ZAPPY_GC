extends MenuButton

var items: PopupMenu = null
var i = 0
# 🧍 `pnw #n X Y O L N` — Player Info
# Player ID 1 is at tile (3,4), facing **East** (O=2), level 1, from team "TeamRocket".

func new_island(x, y):
	i = i + 1
	items.add_item(str("[", x, "]", "[", y, "]    ", "Island", i))


func _on_item_selected(id: int) -> void:
	SignalBus.select_tile.emit(id)


func _ready():
	items = get_popup()
	SignalBus.new_island.connect(new_island)
	items.connect("id_pressed", Callable(self, "_on_item_selected"))
