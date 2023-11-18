extends StaticBody2D

signal toggle_external_shop(external_inventory_owner)
signal set_external_inventory_owner()
signal check_for_new_owner()
signal shop_inv_data_updated

@export var shop_inventory_data: InventoryData
@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@export var shop_name = "Leyla's Plant Shop"
@export var welcome_text = "Welcome, what can I get you?"
@export var type = "Plant Shop"

func _ready():
	connect_signals()

func connect_signals():
	shop_inventory_data.inventory_updated.connect(shop_inventory_data_updated)

func _on_hurtbox_player_interact():
		set_external_inventory_owner.emit(self)
		toggle_external_shop.emit(self)

func shop_item_selected(shop_item, added_quantity):
	var has_item_already = false
	for slot_data in shop_inventory_data.slot_datas:
		if has_item_already == not true and slot_data.item_data and slot_data.item_data.name == shop_item.item_data.name:
			has_item_already = true
			slot_data.quantity -= added_quantity
			###subtract_item_from_shop(added_shop_item)
	shop_inventory_data_updated(shop_inventory_data)
	###if has_item_already == not true:
		#has_item_already = true
		#shop_inventory_data.slot_datas.append(added_shop_item)

#func subtract_item_from_shop(added_shop_item):
	#for slot_data in shop_inventory_data.slot_datas:
		#if slot_data and slot_data.item_data and slot_data.item_data.name == added_shop_item.item_data.name:
			#slot_data.quantity -= added_shop_item.quantity
			#print(slot_data.quantity)

func shop_inventory_data_updated(shop_inventory_data):
	emit_signal("shop_inv_data_updated", shop_inventory_data)

func is_buy_button_disabled():
	pass
