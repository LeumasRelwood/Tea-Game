extends Control

var shop_inventory: InventoryData
@onready var start_button = $PanelContainer/MarginContainer3/StartButton
@onready var v_box_container = $PanelContainer/RecipeScrollContainer/MarginContainer/VBoxContainer
@onready var progress_bar = $PanelContainer/MarginContainer7/ProgressBar
@onready var header_label = $PanelContainer/MarginContainer/HeaderLabel
@onready var welcome_label = $PanelContainer/MarginContainer2/WelcomeLabel
var external_inv_owner

func _ready():
	connect_signals()

func connect_signals():
	for node in get_tree().get_nodes_in_group("shop_items"):
		node.item_selected.connect(shop_item_selected)
	for node in get_tree().get_nodes_in_group("external_withering"):
		node.update_withering_menu.connect(update_withering_menu)
		node.set_external_inventory_owner.connect(set_external_inventory_owner)

func is_start_button_disabled():
	start_button.disabled = external_inv_owner.is_start_button_disabled()

func _on_start_button_pressed():
	if not start_button.disabled:
		external_inv_owner.timer.start()
		external_inv_owner.progress_clicker_timer.start()
		start_button.disabled = true
		external_inv_owner.craft_with_slot_data(0)

func shop_item_selected(shop_item: SlotData):
	external_inv_owner.selected_recipe = shop_item
	start_button.disabled = external_inv_owner.is_start_button_disabled()

func set_external_inventory_owner(external_inventory_owner):
	external_inv_owner = external_inventory_owner


func set_shop_inventory(shop_inventory_data, external_inventory_owner):
	shop_inventory = shop_inventory_data
	header_label.text = external_inventory_owner.shop_name
	welcome_label.text = external_inventory_owner.welcome_text

func clear_shop_inventory(shop_inventory_data):
	shop_inventory = null



func update_withering_menu(_inventory_data_input, _inventory_data_output, type, _craft_quantity):
	start_button.disabled = external_inv_owner.is_start_button_disabled()
