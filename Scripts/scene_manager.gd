extends Control

func start():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")
	'''
	var new_scene = load("res://Scenes/MainScene.tscn").instantiate()

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	'''

func _ready():
	SignalBus.start_game.connect(start)
