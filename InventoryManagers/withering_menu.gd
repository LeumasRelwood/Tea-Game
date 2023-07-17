extends Control

@export var process_time = 5
@export var progress_clicker_time = .1
@export var craft_quantity = 5

@onready var inventory_input = $PanelContainer/MarginContainer8/MarginContainer6/InventoryInput
@onready var inventory_output = $PanelContainer/MarginContainer6/MarginContainer7/InventoryOutput
@onready var start_button = $PanelContainer/MarginContainer3/StartButton
@onready var v_box_container = $PanelContainer/RecipeScrollContainer/MarginContainer/VBoxContainer
@onready var timer = $Timer
@onready var progress_clicker_timer = $Timer/ProgressClickerTimer
@onready var progress_bar = $PanelContainer/MarginContainer7/ProgressBar

#put progress and selected recipe into the machines, not interface
#might also have to code inventory input and output to read machine's inventory
@onready var progress = 0
@export var selected_recipe: SlotData

func _ready():
	timer.wait_time = process_time
	progress_clicker_timer.wait_time = progress_clicker_time
	inventory_input.is_start_button_disabled.connect(is_start_button_disabled)
	for node in get_tree().get_nodes_in_group("withering_recipes"):
		node.recipe_selected.connect(whithering_recipe_selected)

func is_start_button_disabled():
	if selected_recipe:
		for slot_data in inventory_input.inventoryData.slot_datas:
			if not slot_data:
				start_button.disabled = true
			else:
				if not inventory_output.inventoryData.slot_datas[0]:
					start_button.disabled = false
				else:
					start_button.disabled = true

func _on_start_button_pressed():
	if not start_button.disabled:
		timer.start()
		progress_clicker_timer.start()
		start_button.disabled = true
		inventory_input.craft_with_slot_data(craft_quantity, 0)

func whithering_recipe_selected(recipe_item: SlotData):
	selected_recipe = recipe_item
	is_start_button_disabled()

func _on_timer_timeout():
	if inventory_output.set_item_output(selected_recipe, craft_quantity, 0):
		progress_clicker_timer.stop()
		progress = 0
		progress_bar.value = progress
		is_start_button_disabled()


func _on_progress_clicker_timer_timeout():
	progress += progress_clicker_time / process_time * 100
	progress_bar.value = progress
