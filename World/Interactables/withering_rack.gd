extends StaticBody2D

signal toggle_external_withering(external_inventory_owner)

@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@export var inventory_data_input: InventoryDataWithering
@export var inventory_data_output: InventoryData

func _on_hurtbox_player_interact():
		toggle_external_withering.emit(self)
