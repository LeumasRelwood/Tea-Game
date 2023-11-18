extends ScrollContainer

signal is_start_button_disabled
signal cart_item_selected

const shop_item_container = preload("res://World/Interactables/shop_item_container.tscn")

@onready var v_box_container = $MarginContainer/VBoxContainer

@export var inventoryData: InventoryData

func shop_item_selected(shopping_cart):
	populate_item_grid(shopping_cart)



func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: InventoryData) -> void:
	inventoryData = inventory_data
	
	for child in v_box_container.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		if slot_data:
			var Shop_Item_Container = shop_item_container.instantiate()
			v_box_container.add_child(Shop_Item_Container)
		
			Shop_Item_Container.item_selected.connect(item_selected)
			Shop_Item_Container.set_container_data(slot_data)
	
			emit_signal("is_start_button_disabled")

func item_selected(shop_item):
	emit_signal("cart_item_selected", shop_item)



func craft_with_slot_data(quantity, index: int) -> void:
	inventoryData.craft_with_slot_data(quantity, index)

func set_item_output(selected_recipe, craft_quantity, index) -> bool:
	if inventoryData.set_item_output(selected_recipe, craft_quantity, index):
		return true
	return false

