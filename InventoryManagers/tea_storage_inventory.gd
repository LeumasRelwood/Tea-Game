extends Control

@onready var storage_inventory = $PanelContainer/MarginContainer8/StorageInventory
@onready var storage_inventory_data: InventoryDataFinishedTea
@onready var header_label = $PanelContainer/MarginContainer/HeaderLabel
@onready var capacity_label = $PanelContainer/MarginContainer2/CapacityLabel
@onready var current_storage_label = $PanelContainer/MarginContainer3/CurrentStorageLabel
var external_inv_owner

func _ready():
	connect_signals()

func connect_signals():
	for node in get_tree().get_nodes_in_group("external_tea_storage"):
		node.update_tea_storage_inventory.connect(update_tea_storage_inventory)
		node.set_external_inventory_owner.connect(set_external_inventory_owner)
		node.check_for_new_owner.connect(check_for_new_owner)

func set_external_inventory_owner(external_inventory_owner):
	external_inv_owner = external_inventory_owner

func update_tea_storage_inventory(_storage_inventory_data, type, capacity, current_leaf_total):
	storage_inventory_data = _storage_inventory_data
	storage_inventory.set_inventory_data(storage_inventory_data)
	header_label.text = str(type)
	capacity_label.text = (str(current_leaf_total) + " leaves stored of " + str(capacity) + " capacity.")

func check_for_new_owner():
	external_inv_owner.reupdate_tea_storage_inventory()
