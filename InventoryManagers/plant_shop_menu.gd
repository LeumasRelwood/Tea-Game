extends Control

var shop_inventory: InventoryData
var external_inv_owner
var shopping_cart_total: int
var user
@export var shopping_cart: InventoryData
@onready var buy_button = $PanelContainer/MarginContainer3/BuyButton
@onready var v_box_container = $PanelContainer/RecipeScrollContainer/MarginContainer/VBoxContainer
@onready var progress_bar = $PanelContainer/MarginContainer7/ProgressBar
@onready var header_label = $PanelContainer/MarginContainer/HeaderLabel
@onready var welcome_label = $PanelContainer/MarginContainer2/WelcomeLabel
@onready var inventory_scroll_container = $PanelContainer/MarginContainer4/InventoryScrollContainer
@onready var selected_shop_scroll_container = $PanelContainer/MarginContainer5/SelectedShopScrollContainer
@onready var cost_label = $PanelContainer/MarginContainer6/CostLabel

func _ready():
	connect_signals()

func connect_signals():
	#for node in get_tree().get_nodes_in_group("shop_items"):
		#node.item_selected.connect(shop_item_selected)
	inventory_scroll_container.shop_item_selected.connect(shop_item_selected)
	selected_shop_scroll_container.cart_item_selected.connect(cart_item_selected)
	for node in get_tree().get_nodes_in_group("external_shop"):
		#node.update_withering_menu.connect(update_withering_menu)
		node.set_external_inventory_owner.connect(set_external_inventory_owner)
		node.shop_inv_data_updated.connect(shop_inv_data_updated)

func _on_buy_button_pressed():
	if not buy_button.disabled:
		PlayerStats.coins -= shopping_cart_total
		user.add_bought_items(shopping_cart.slot_datas)
		shopping_cart.slot_datas.clear()
		update_menu()

func is_buy_button_disabled() -> bool :
	if shopping_cart.slot_datas.size() > 0:
		if shopping_cart_total >= PlayerStats.coins:
			return true
		else:
			return false
	else:
		return true
	#buy_button.disabled = external_inv_owner.is_buy_button_disabled()

func cart_item_selected(cart_item: SlotData):
	var added_quantity = 1
	
	for slot_data in shopping_cart.slot_datas:
		if slot_data.item_data and slot_data.item_data.name == cart_item.item_data.name:
			if slot_data.quantity > 1:
				slot_data.quantity -= added_quantity
			elif slot_data.quantity == 1:
				shopping_cart.slot_datas.erase(slot_data)

	external_inv_owner.cart_item_selected(cart_item, added_quantity)
	update_menu()


func shop_item_selected(shop_item: SlotData):
	#var added_shop_item = shop_item
	var added_quantity = 1
	
	var has_item_already = false
	for slot_data in shopping_cart.slot_datas:
		if has_item_already == not true and slot_data.item_data and slot_data.item_data.name == shop_item.item_data.name:
			has_item_already = true
			slot_data.quantity += added_quantity
	if has_item_already == not true:
		has_item_already = true
		var slot = SlotData.new()
		slot.item_data = shop_item.item_data
		slot.quantity = added_quantity
		shopping_cart.slot_datas.append(slot)

	external_inv_owner.shop_item_selected(shop_item, added_quantity)
	update_menu()

func update_menu():
	shopping_cart_total = 0
	for slot_data in shopping_cart.slot_datas:
		if slot_data and slot_data.item_data:
			shopping_cart_total += slot_data.item_data.base_value * slot_data.quantity
	cost_label.text = str("Total Cost: " + str(shopping_cart_total))
	buy_button.disabled = is_buy_button_disabled()
	selected_shop_scroll_container.shop_item_selected(shopping_cart)

func set_external_inventory_owner(external_inventory_owner):
	external_inv_owner = external_inventory_owner

func shop_inv_data_updated(shop_inventory_data):
	inventory_scroll_container.set_inventory_data(shop_inventory_data)

func set_shop_inventory(_user, shop_inventory_data, external_inventory_owner):
	user = _user
	shop_inventory = shop_inventory_data
	header_label.text = external_inventory_owner.shop_name
	welcome_label.text = external_inventory_owner.welcome_text
	inventory_scroll_container.set_inventory_data(shop_inventory)
	inventory_scroll_container.shop_item_selected.connect(shop_item_selected)
	update_menu()

func clear_shop_inventory(shop_inventory_data):
	for slot_data in shopping_cart.slot_datas:
		external_inv_owner.cart_item_selected(slot_data, slot_data.quantity)
		#if slot_data.item_data and slot_data.item_data.name == cart_item.item_data.name:
			#if slot_data.quantity > 1:
				#slot_data.quantity -= added_quantity
			#elif slot_data.quantity == 1:
				#shopping_cart.slot_datas.erase(slot_data)

	external_inv_owner = null
	shopping_cart.slot_datas.clear()
	#shop_inventory.slot_datas.clear()
	#inventory_scroll_container.set_inventory_data(shop_inventory)
	update_menu()



#func update_withering_menu(_inventory_data_input, _inventory_data_output, type, _craft_quantity):
	#buy_button.disabled = external_inv_owner.is_start_button_disabled()
	
	#var has_item = false
		#for slot_data in external_inv_owner.shop_inventory_data.slot_datas:
			#if has_item == not true and slot_data.item_data and slot_data.item_data.name == shop_item.item_data.name:
				#has_item = true
		#if has_item == not true:
			#return true
		#else:
			#return false
