extends PanelContainer

signal is_start_button_disabled

const Slot = preload("res://InventoryManagers/slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

var inventoryData: InventoryData

func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	inventoryData = inventory_data
	
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		slot.set_slot_data(slot_data)
	
		emit_signal("is_start_button_disabled")

func craft_with_slot_data(quantity, index: int) -> void:
	inventoryData.craft_with_slot_data(quantity, index)

func set_item_output(selected_recipe, craft_quantity, index) -> bool:
	if inventoryData.set_item_output(selected_recipe, craft_quantity, index):
		return true
	return false

