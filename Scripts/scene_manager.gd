extends Control

func start():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")

func _ready():
	SignalBus.start_game.connect(start)
