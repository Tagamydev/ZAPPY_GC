extends MenuButton

var items: PopupMenu = null

# 🧍 `pnw #n X Y O L N` — Player Info
# Player ID 1 is at tile (3,4), facing **East** (O=2), level 1, from team "TeamRocket".

	
func _on_item_selected(id: int) -> void:
	print(items.get_item_text(id))
	SignalBus.select_player.emit(id)

func addPlayer(number, team):
	items.add_item(str("Player ", number))
	

func _ready():
	items = get_popup()
	SignalBus.new_player.connect(addPlayer)
	items.connect("id_pressed", Callable(self, "_on_item_selected"))
