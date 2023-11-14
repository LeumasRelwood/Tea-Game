extends StaticBody2D

signal toggle_external_shop(external_inventory_owner)
signal set_external_inventory_owner()
signal check_for_new_owner()

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

func shop_inventory_data_updated():
	pass
