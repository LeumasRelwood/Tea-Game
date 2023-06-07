extends "res://Hit and Hurtboxes/hitbox.gd"

@onready var player = $"../.."

var knockback_vector = Vector2.ZERO
@export var inventory_data: InventoryData
