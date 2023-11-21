extends "res://Hit and Hurtboxes/hitbox.gd"

signal conversation_start
signal conversation_finish

@onready var player = $"../.."

var knockback_vector = Vector2.ZERO
@export var inventory_data: InventoryData

func conversation_started():
	conversation_start.emit()

func conversation_finished():
	conversation_finish.emit()
