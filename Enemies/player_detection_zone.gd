extends Area2D

@onready var player = null

func _on_body_entered(body):
	player = body

func _on_body_exited(body):
	player = null

func can_see_player():
	return player != null
