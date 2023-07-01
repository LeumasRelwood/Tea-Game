extends Control

@onready var inventory_input = $PanelContainer/MarginContainer8/MarginContainer6/InventoryInput
@onready var inventory_output = $PanelContainer/MarginContainer6/MarginContainer7/InventoryOutput
@onready var start_button = $PanelContainer/MarginContainer3/StartButton
@onready var v_box_container = $PanelContainer/RecipeScrollContainer/MarginContainer/VBoxContainer
var selected_recipe: ItemData
@export var craft_quantity = 5

func _ready():
	inventory_input.is_start_button_disabled.connect(is_start_button_disabled)
	for node in get_tree().get_nodes_in_group("withering_recipes"):
		node.recipe_selected.connect(whithering_recipe_selected)

func is_start_button_disabled(inventory_data: InventoryData):
	for slot_data in inventory_data.slot_datas:
		if not slot_data:
			start_button.disabled = true
		else:
			start_button.disabled = false

func _on_start_button_pressed():
	inventory_output.set_item_output(selected_recipe, craft_quantity, 0)

func whithering_recipe_selected(recipe_item: ItemData):
	selected_recipe = recipe_item
