extends Node3D
@onready var animationplayer: AnimationPlayer = $AnimationPlayer

func play_portal_animation():
	animationplayer.play("PortalAnimation")
