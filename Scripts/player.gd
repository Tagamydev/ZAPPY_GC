extends Node3D

var	Character : Characters = Characters.new()

func	_ready():
	Character.object = self
	print("I'm alive mtf")
