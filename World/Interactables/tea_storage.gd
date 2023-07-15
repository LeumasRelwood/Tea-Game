extends StaticBody2D

signal toggle_external_tea_storage(external_inventory_owner)
signal update_tea_storage_inventory(storage_inventory_data, type, capacity, current_leaf_total)
signal set_external_inventory_owner()
signal check_for_new_owner()

@export var tea_storage_inventory_data: InventoryDataFinishedTea
@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@onready var current_leaf_total: int
@export var type = "Tea Storage Shed"
@export var capacity = 200

func _ready():
	tea_storage_inventory_data.inventory_updated.connect(tea_storage_inventory_data_updated)

func _on_hurtbox_player_interact():
		set_external_inventory_owner.emit(self)
		toggle_external_tea_storage.emit(self)
		check_current_leaf_total()
		update_tea_storage_inventory.emit(tea_storage_inventory_data, type, capacity, current_leaf_total)

func tea_storage_inventory_data_updated(inventory_data):
	check_current_leaf_total()
	update_tea_storage_inventory.emit(tea_storage_inventory_data, type, capacity, current_leaf_total)

func reupdate_tea_storage_inventory():
	update_tea_storage_inventory.emit(tea_storage_inventory_data, type, capacity, current_leaf_total)

func check_current_leaf_total():
	current_leaf_total = 0
	for slot_data in tea_storage_inventory_data.slot_datas:
		if slot_data:
			current_leaf_total += slot_data.quantity
