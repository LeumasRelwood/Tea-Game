extends Control

signal force_close_external
signal force_close_withering
signal force_close_drying
signal force_close_tea_storage

var grabbed_slot_data: SlotData
var external_inventory_owner = null

@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory = $ExternalInventory
@onready var withering_menu = $WitheringMenu
@onready var drying_menu = $DryingMenu
@onready var tea_storage_inventory = $TeaStorageInventory
var buildable_tile_map

func _physics_process(delta: float) -> void:
	if grabbed_slot.visible and get_node("/root/World").mouse_in_build_area and grabbed_slot_data.item_data is ItemDataBuildable:
		var mouse_tile = get_node("/root/World").buildable_tile_map.local_to_map(get_global_mouse_position())
		var local_pos = get_node("/root/World").buildable_tile_map.map_to_local(mouse_tile)
		grabbed_slot.global_position = get_node("/root/World").buildable_tile_map.to_global(local_pos) - Vector2(8, 8)
	else:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(1, 1)

	if external_inventory_owner \
			and self.visible \
			and external_inventory_owner.global_position.distance_to(PlayerStats.get_global_position()) > 64:
		if external_inventory.visible:
			force_close_external.emit(external_inventory_owner)
		elif withering_menu.visible:
			force_close_withering.emit(external_inventory_owner)
		elif drying_menu.visible:
			force_close_drying.emit(external_inventory_owner)
		elif tea_storage_inventory.visible:
			force_close_tea_storage.emit(external_inventory_owner)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)	

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)

func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		external_inventory.hide()
		external_inventory_owner = null

func set_external_withering(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data_input = external_inventory_owner.inventory_data_input
	var inventory_data_output = external_inventory_owner.inventory_data_output
	
	inventory_data_input.inventory_interact.connect(on_inventory_interact)
	inventory_data_output.inventory_interact.connect(on_inventory_interact)
	withering_menu.inventory_input.set_inventory_data(inventory_data_input)
	withering_menu.inventory_output.set_inventory_data(inventory_data_output)

func clear_external_withering() -> void:
	if external_inventory_owner:
		var inventory_data_input = external_inventory_owner.inventory_data_input
		var inventory_data_output = external_inventory_owner.inventory_data_output
		
		inventory_data_input.inventory_interact.disconnect(on_inventory_interact)
		inventory_data_output.inventory_interact.disconnect(on_inventory_interact)
		withering_menu.inventory_input.clear_inventory_data(inventory_data_input)
		withering_menu.inventory_output.clear_inventory_data(inventory_data_output)
		
		withering_menu.hide()
		external_inventory_owner = null

func set_external_drying(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data_input = external_inventory_owner.inventory_data_input
	var inventory_data_output = external_inventory_owner.inventory_data_output
	
	inventory_data_input.inventory_interact.connect(on_inventory_interact)
	inventory_data_output.inventory_interact.connect(on_inventory_interact)
	drying_menu.inventory_input.set_inventory_data(inventory_data_input)
	drying_menu.inventory_output.set_inventory_data(inventory_data_output)

func clear_external_drying() -> void:
	if external_inventory_owner:
		var inventory_data_input = external_inventory_owner.inventory_data_input
		var inventory_data_output = external_inventory_owner.inventory_data_output
		
		inventory_data_input.inventory_interact.disconnect(on_inventory_interact)
		inventory_data_output.inventory_interact.disconnect(on_inventory_interact)
		drying_menu.inventory_input.clear_inventory_data(inventory_data_input)
		drying_menu.inventory_output.clear_inventory_data(inventory_data_output)
		
		drying_menu.hide()
		external_inventory_owner = null

func set_external_tea_storage(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var tea_storage_inventory_data = external_inventory_owner.tea_storage_inventory_data
	
	tea_storage_inventory_data.inventory_interact.connect(on_inventory_interact)
	tea_storage_inventory.storage_inventory.set_inventory_data(tea_storage_inventory_data)

func clear_external_tea_storage() -> void:
	if external_inventory_owner:
		var tea_storage_inventory_data = external_inventory_owner.tea_storage_inventory_data
		
		tea_storage_inventory_data.inventory_interact.disconnect(on_inventory_interact)
		tea_storage_inventory.inventory_input.clear_inventory_data(tea_storage_inventory_data)
		
		tea_storage_inventory.hide()
		external_inventory_owner = null

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _input(event):
	if grabbed_slot_data and grabbed_slot_data.item_data is ItemDataBuildable \
	and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() \
	and grabbed_slot.visible and get_node("/root/World").mouse_in_build_area:
		var Slot_Object = load(grabbed_slot_data.item_data.object_scene)
		var slot_object = Slot_Object.instantiate()
		get_node("../../").get_child(3).get_node("YSort").add_child(slot_object)
		slot_object.owner = get_node("../../").get_child(3)
		slot_object.followMouse()
		if slot_object.has_method("planted"):
			slot_object.planted()
		
		grabbed_slot_data.quantity -= 1
		if grabbed_slot_data.quantity == 0:
			grabbed_slot_data = null
		update_grabbed_slot()
