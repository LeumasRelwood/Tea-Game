extends VBoxContainer

signal is_start_button_disabled
signal shop_item_selected

const recipe_item_container = preload("res://InventoryManagers/RecipeItemContainers/recipe_item_container.tscn")

@onready var v_box_container = $MarginContainer/VBoxContainer

var inventoryData: InventoryData

func set_inventory_data(UnlockedTeaRecipes) -> void:
	#inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(UnlockedTeaRecipes)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	pass
	#inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(UnlockedTeaRecipes) -> void:
	#inventoryData = inventory_data
	
	for child in v_box_container.get_children():
		child.queue_free()
	
	for slot_data in UnlockedTeaRecipes:
		if slot_data:
			if slot_data.unlocked == true:
				var Recipe_Item_Container = recipe_item_container.instantiate()
				v_box_container.add_child(Recipe_Item_Container)
			
				Recipe_Item_Container.recipe_selected.connect(item_selected)
				Recipe_Item_Container.set_container_data(slot_data)
		
				emit_signal("is_start_button_disabled")

func item_selected(shop_item):
	emit_signal("shop_item_selected", shop_item)

