extends Control

@onready var inventory_input = $PanelContainer/MarginContainer8/MarginContainer6/InventoryInput
@onready var inventory_output = $PanelContainer/MarginContainer6/MarginContainer7/InventoryOutput
@onready var start_button = $PanelContainer/MarginContainer3/StartButton
@onready var v_box_container = $PanelContainer/RecipeScrollContainer/MarginContainer/VBoxContainer
var selected_recipe: ItemData

func _ready():
	inventory_input.is_start_button_disabled.connect(is_start_button_disabled)

func is_start_button_disabled(inventory_data: InventoryData):
	for slot_data in inventory_data.slot_datas:
		if not slot_data:
			start_button.disabled = true
		else:
			start_button.disabled = false

func _on_start_button_pressed():
	inventory_output.inventory_data.slot_datas[1] = selected_recipe

func _on_white_tea_recipe_item_container_recipe_selected(recipe_item: ItemData):
	selected_recipe = recipe_item

func _on_black_tea_recipe_item_container_recipe_selected(recipe_item: ItemData):
	selected_recipe = recipe_item

func _on_oolong_tea_recipe_item_container_recipe_selected(recipe_item: ItemData):
	selected_recipe = recipe_item
