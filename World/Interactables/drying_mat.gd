extends StaticBody2D

signal toggle_external_drying(external_inventory_owner)
signal update_drying_menu(inventory_data_input, inventory_data_output, type, craft_quantity)
signal update_progress_bar(progress)
signal set_external_inventory_owner()
signal check_for_new_owner()

@export var inventory_data_input: InventoryDataDryable
@export var inventory_data_output: InventoryDataFinishedTea
@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@onready var timer = $Timer
@onready var progress_clicker_timer = $Timer/ProgressClickerTimer
@onready var in_progress: bool = false
@onready var craft_quantity: int
@export var type = "Bamboo Drying Mat"
@export var process_time = 5
@export var progress_clicker_time = .1
@export var capacity = 5
@export var progress = 0
@export var selected_recipe: SlotData = null

func _ready():
	timer.wait_time = process_time
	progress_clicker_timer.wait_time = progress_clicker_time

func _on_hurtbox_player_interact(user):
		set_external_inventory_owner.emit(self)
		toggle_external_drying.emit(self)
		update_drying_menu.emit(inventory_data_input, inventory_data_output, type, capacity)
		update_progress_bar.emit(progress)
		is_start_button_disabled()

func reupdate_drying_menu():
	update_drying_menu.emit(inventory_data_input, inventory_data_output, type, capacity)

func _on_timer_timeout():
	if inventory_data_output.set_item_output(selected_recipe, craft_quantity, 0):
		progress_clicker_timer.stop()
		progress = 0
		update_progress_bar.emit(progress)
		check_for_new_owner.emit()
		in_progress = false
		is_start_button_disabled()

func _on_progress_clicker_timer_timeout():
	progress += progress_clicker_time / process_time * 100
	in_progress = true
	update_progress_bar.emit(progress)

func is_start_button_disabled():
	if in_progress == false:
		for slot_data in inventory_data_input.slot_datas:
			if not slot_data:
				return true
			else:
				if not inventory_data_output.slot_datas[0]:
					return false
				else:
					return true
	else:
		return true

func set_recipe():
	selected_recipe = inventory_data_input.slot_datas[0].item_data.next_stage

func craft_with_slot_data(index):
	craft_quantity = clamp(inventory_data_input.slot_datas[index].quantity, 1, capacity)
	inventory_data_input.craft_with_slot_data(craft_quantity, index)
