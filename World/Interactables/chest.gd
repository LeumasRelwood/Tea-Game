extends StaticBody2D

signal toggle_inventory(external_inventory_owner)
signal toggle_external_inventory(external_inventory_owner)

@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@export var inventory_data: InventoryData

func _on_hurtbox_player_interact():
		toggle_inventory.emit(self)
