extends Node

@export var tea_storage_inventory_data: InventoryDataFinishedTea

func _ready():
	for node in get_tree().get_nodes_in_group("external_tea_storage"):
		node.update_tea_storage_inventory.connect(update_tea_storage_inventory)

func update_tea_storage_inventory(_tea_storage_inventory_data, type, capacity, current_leaf_total):
	tea_storage_inventory_data = _tea_storage_inventory_data

func relay_global_tea_storage():
	get_tree().call_group("external_tea_storage", "tea_storage_inventory_data_updated", tea_storage_inventory_data)
