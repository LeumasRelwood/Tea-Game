extends Control

signal force_close_external
signal force_close_withering

var grabbed_slot_data: SlotData
var external_inventory_owner

@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory = $ExternalInventory
@onready var equip_inventory = $EquipInventory
@onready var withering_menu = $WitheringMenu

func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(1, 1)
	
	if external_inventory_owner \
			and self.visible \
			and external_inventory_owner.global_position.distance_to(PlayerStats.get_global_position()) > 40:
		if external_inventory.visible:
			force_close_external.emit(external_inventory_owner)
		elif withering_menu.visible:
			force_close_withering.emit(external_inventory_owner)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)	

func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

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
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		withering_menu.inventory_input.clear_inventory_data(inventory_data)
		withering_menu.inventory_output.clear_inventory_data(inventory_data)
		
		withering_menu.hide()
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
