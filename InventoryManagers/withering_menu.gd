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
@onready var progress = 0

var selected_recipe: SlotData

func _ready():
	timer.wait_time = process_time
	progress_clicker_timer.wait_time = progress_clicker_time
	inventory_input.is_start_button_disabled.connect(is_start_button_disabled)
	for node in get_tree().get_nodes_in_group("withering_recipes"):
		node.recipe_selected.connect(whithering_recipe_selected)

#func _process(delta):
	#progress = timer.get_time_left / process_time
	#progress_bar.value = progress

func is_start_button_disabled(inventory_data: InventoryData):
	#check to see that output inventory is also clear
	#check to see that recipe is selected
	for slot_data in inventory_data.slot_datas:
		if not slot_data:
			start_button.disabled = true
		else:
			start_button.disabled = false

func _on_start_button_pressed():
	timer.start()
	progress_clicker_timer.start()

func whithering_recipe_selected(recipe_item: SlotData):
	selected_recipe = recipe_item

func _on_timer_timeout():
	if inventory_output.set_item_output(selected_recipe, craft_quantity, 0):
		inventory_input.craft_with_slot_data(craft_quantity, 0)
		progress_clicker_timer.stop()
		progress = 0
		progress_bar.value = progress

func _on_progress_clicker_timer_timeout():
	progress += progress_clicker_time / process_time * 100
	progress_bar.value = progress
