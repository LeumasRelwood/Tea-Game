extends Control

@onready var inventory_input = $PanelContainer/MarginContainer8/MarginContainer6/InventoryInput
@onready var inventory_output = $PanelContainer/MarginContainer6/MarginContainer7/InventoryOutput
@onready var inventory_data_input: InventoryData
@onready var inventory_data_output: InventoryData
@onready var start_button = $PanelContainer/MarginContainer3/StartButton
@onready var progress_bar = $PanelContainer/MarginContainer7/ProgressBar
@onready var header_label = $PanelContainer/MarginContainer/HeaderLabel
@onready var capacity_label = $PanelContainer/MarginContainer2/CapacityLabel
@onready var craft_quantity = null
var external_inv_owner

func _ready():
	connect_signals()

func connect_signals():
	inventory_input.is_start_button_disabled.connect(is_start_button_disabled)
	inventory_output.is_start_button_disabled.connect(is_start_button_disabled)
	for node in get_tree().get_nodes_in_group("external_fixing"):
		node.update_fixing_menu.connect(update_fixing_menu)
		node.update_progress_bar.connect(update_progress_bar)
		node.set_external_inventory_owner.connect(set_external_inventory_owner)
		node.check_for_new_owner.connect(check_for_new_owner)

func is_start_button_disabled():
		start_button.disabled = external_inv_owner.is_start_button_disabled()

func _on_start_button_pressed():
	if not start_button.disabled:
		external_inv_owner.set_recipe()
		external_inv_owner.timer.start()
		external_inv_owner.progress_clicker_timer.start()
		start_button.disabled = true
		external_inv_owner.craft_with_slot_data(0)

func set_external_inventory_owner(external_inventory_owner):
	external_inv_owner = external_inventory_owner

func update_fixing_menu(_inventory_data_input, _inventory_data_output, type, _craft_quantity):
	inventory_data_input = _inventory_data_input
	inventory_data_output = _inventory_data_output
	inventory_input.set_inventory_data(inventory_data_input)
	inventory_output.set_inventory_data(inventory_data_output)
	craft_quantity = _craft_quantity
	start_button.disabled = external_inv_owner.is_start_button_disabled()
	header_label.text = str(type)
	capacity_label.text = ("Capacity: " +  str(craft_quantity) + " Processed Tea Leaves")

func update_progress_bar(progress):
	progress_bar.value = external_inv_owner.progress
	start_button.disabled = external_inv_owner.is_start_button_disabled()

func check_for_new_owner():
	external_inv_owner.reupdate_fixing_menu()
