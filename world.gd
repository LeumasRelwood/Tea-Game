extends Node2D

@onready var inventory_interface = $UI/InventoryInterface
@onready var player = $Level/YSort/Player
@onready var hot_bar_inventory = $UI/HotBarInventory
@onready var player_inventory = $UI/InventoryInterface/PlayerInventory
@onready var external_inventory = $UI/InventoryInterface/ExternalInventory
@onready var withering_menu = $UI/InventoryInterface/WitheringMenu
@onready var drying_menu = $UI/InventoryInterface/DryingMenu
@onready var tea_storage_inventory = $UI/InventoryInterface/TeaStorageInventory
@onready var tea_market = $UI/TeaMarket
@onready var plant_shop_menu = $UI/InventoryInterface/PlantShopMenu
@onready var fermenting_menu = $UI/InventoryInterface/FermentingMenu
@onready var killgreen_menu = $UI/InventoryInterface/KillgreenMenu
@onready var oxidization_menu = $UI/InventoryInterface/OxidizationMenu
@onready var pressing_menu = $UI/InventoryInterface/PressingMenu
@onready var rolling_menu = $UI/InventoryInterface/RollingMenu



var mouse_in_build_area = false
var buildable_tile_map: TileMap

func _ready():
	connect_signals()

func connect_signals():
	inventory_interface.connect_signals.connect(connect_signals)
	for p in get_tree().get_nodes_in_group("player"):
		player = p
	player.toggle_inventory.connect(toggle_inventory_interface)
	player.toggle_tea_market.connect(toggle_tea_market)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	inventory_interface.force_close_external.connect(toggle_external_inventory_interface)
	inventory_interface.force_close_withering.connect(toggle_external_withering_interface)
	inventory_interface.force_close_drying.connect(toggle_external_drying_interface)
	inventory_interface.force_close_fermenting.connect(toggle_external_fermentation_interface)
	inventory_interface.force_close_fixing.connect(toggle_external_fixing_interface)
	inventory_interface.force_close_oxidizing.connect(toggle_external_oxidizing_interface)
	inventory_interface.force_close_pressing.connect(toggle_external_pressing_interface)
	inventory_interface.force_close_rolling.connect(toggle_external_rolling_interface)
	inventory_interface.force_close_tea_storage.connect(toggle_external_tea_storage)
	inventory_interface.force_close_shop.connect(clear_external_shop)
	GlobalTeaStorage.connect_signals()
	
	for node in get_tree().get_nodes_in_group("inventory_menus"):
		node.connect_signals()

	for node in get_tree().get_nodes_in_group("buildable_tile_maps"):
		buildable_tile_map = node

	for node in get_tree().get_nodes_in_group("buildable_areas"):
		node.mouse_entered.connect(_on_buildable_area_mouse_entered)
		node.mouse_exited.connect(_on_buildable_area_mouse_exited)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_external_inventory.connect(toggle_external_inventory_interface)
	
	for node in get_tree().get_nodes_in_group("external_withering"):
		node.toggle_external_withering.connect(toggle_external_withering_interface)
	
	for node in get_tree().get_nodes_in_group("external_drying"):
		node.toggle_external_drying.connect(toggle_external_drying_interface)
	
	for node in get_tree().get_nodes_in_group("external_fermenting"):
		node.toggle_external_fermentation.connect(toggle_external_fermentation_interface)
	
	for node in get_tree().get_nodes_in_group("external_fixing"):
		node.toggle_external_fixing.connect(toggle_external_fixing_interface)
	
	for node in get_tree().get_nodes_in_group("external_oxidizing"):
		node.toggle_external_oxidizing.connect(toggle_external_oxidizing_interface)
	
	for node in get_tree().get_nodes_in_group("external_pressing"):
		node.toggle_external_pressing.connect(toggle_external_pressing_interface)
	
	for node in get_tree().get_nodes_in_group("external_rolling"):
		node.toggle_external_rolling.connect(toggle_external_rolling_interface)
	
	for node in get_tree().get_nodes_in_group("external_tea_storage"):
		node.toggle_external_tea_storage.connect(toggle_external_tea_storage)
	
	for node in get_tree().get_nodes_in_group("map_changers"):
		node.change_map.connect(change_map)
	
	for node in get_tree().get_nodes_in_group("external_shop"):
		node.toggle_external_shop.connect(toggle_external_shop_interface)

func toggle_tea_market():
	tea_market.visible = not tea_market.visible

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	player_inventory.visible = not player_inventory.visible
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()
	
	if external_inventory.visible:
		external_inventory_controller(external_inventory_owner)
	elif withering_menu.visible:
		external_withering_controller(external_inventory_owner)
	elif drying_menu.visible:
		external_drying_controller(external_inventory_owner)

func toggle_external_inventory_interface(external_inventory_owner = null) -> void:
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_inventory_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_inventory(external_inventory_owner)
		external_inventory.visible = not external_inventory.visible
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()

func external_inventory_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_inventory(external_inventory_owner)
		external_inventory.show()
	else:
		inventory_interface.clear_external_inventory()

func toggle_external_withering_interface(external_inventory_owner = null) -> void:
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_withering_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_withering(external_inventory_owner)
		withering_menu.visible = not withering_menu.visible
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()

func external_withering_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_withering(external_inventory_owner)
		withering_menu.show()
	else:
		inventory_interface.clear_external_withering()

func toggle_external_drying_interface(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_drying_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_drying(external_inventory_owner)
		drying_menu.visible = not drying_menu.visible
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()

func external_drying_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_drying(external_inventory_owner)
		drying_menu.show()
	else:
		inventory_interface.clear_external_drying()

func toggle_external_tea_storage(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_tea_storage_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_tea_storage(external_inventory_owner)
		tea_storage_inventory.visible = not tea_storage_inventory.visible
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()

func external_tea_storage_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_tea_storage(external_inventory_owner)
		tea_storage_inventory.show()
	else:
		inventory_interface.clear_external_tea_storage()

func toggle_external_shop_interface(user, external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_shop_controller(user, external_inventory_owner)
	else:
		inventory_interface.set_external_shop(user, external_inventory_owner)
		plant_shop_menu.visible = not plant_shop_menu.visible
	
	if plant_shop_menu.visible == false:
		inventory_interface.clear_external_shop()
	
	#if inventory_interface.visible:
		#hot_bar_inventory.hide()
	#else:
		#hot_bar_inventory.show()

func external_shop_controller(user, external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_shop(user, external_inventory_owner)
		plant_shop_menu.show()
	else:
		inventory_interface.clear_external_shop()

func clear_external_shop(external_inventory_owner):
	plant_shop_menu.hide()
	inventory_interface.clear_external_shop()

func toggle_external_fermentation_interface(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_fermentation_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_fermentation(external_inventory_owner)
		fermenting_menu.visible = not fermenting_menu.visible

func external_fermentation_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_fermentation(external_inventory_owner)
		fermenting_menu.show()
	else:
		inventory_interface.clear_external_fermentation()

func toggle_external_fixing_interface(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_fixing_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_fixing(external_inventory_owner)
		killgreen_menu.visible = not killgreen_menu.visible

func external_fixing_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_fixing(external_inventory_owner)
		killgreen_menu.show()
	else:
		inventory_interface.clear_external_fixing()

func toggle_external_oxidizing_interface(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_oxidizing_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_oxidizing(external_inventory_owner)
		oxidization_menu.visible = not oxidization_menu.visible

func external_oxidizing_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_oxidizing(external_inventory_owner)
		oxidization_menu.show()
	else:
		inventory_interface.clear_external_oxidizing()

func toggle_external_pressing_interface(external_inventory_owner = null):
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_pressing_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_pressing(external_inventory_owner)
		pressing_menu.visible = not pressing_menu.visible

func external_pressing_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_pressing(external_inventory_owner)
		pressing_menu.show()
	else:
		inventory_interface.clear_external_pressing()

func toggle_external_rolling_interface(external_inventory_owner = null):
	print("toggle rolling")
	if not player_inventory.visible:
		inventory_interface.visible = not inventory_interface.visible
		player_inventory.visible = not player_inventory.visible
		external_rolling_controller(external_inventory_owner)
	else:
		inventory_interface.set_external_rolling(external_inventory_owner)
		rolling_menu.visible = not rolling_menu.visible

func external_rolling_controller(external_inventory_owner = null):
	if external_inventory_owner and inventory_interface:
		inventory_interface.set_external_rolling(external_inventory_owner)
		rolling_menu.show()
	else:
		inventory_interface.clear_external_rolling()

func _on_buildable_area_mouse_entered():
	mouse_in_build_area = true

func _on_buildable_area_mouse_exited():
	mouse_in_build_area = false

func change_map(current_map_path, next_map_path, player_position):
	save_scene(current_map_path)
	call_deferred("change_map_deferred", next_map_path, player_position)
	inventory_interface.external_inventory_owner = null

func change_map_deferred(next_map_path, player_position):
	var next_map = load(next_map_path)
	get_child(3).call_deferred("free")
	var level = next_map.instantiate()
	add_child(level)
	
	for player in get_tree().get_nodes_in_group("player"):
		player.position = player_position
	
	connect_signals()

func save_scene(current_map_path):
	var scene = PackedScene.new()
	scene.pack(get_child(3))
	ResourceSaver.save(scene, current_map_path)
