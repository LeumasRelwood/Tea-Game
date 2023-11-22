extends StaticBody2D

signal toggle_external_inventory(external_inventory_owner)

@onready var global = get_node("/root/Global")
@onready var hurtbox = $Hurtbox
@export var inventory_data: InventoryData

func _on_hurtbox_player_interact(user):
		toggle_external_inventory.emit(self)



var MouseSelected = false
var mouse_offset = Vector2.ZERO

func _process(delta):
	if MouseSelected:
		followMouse()

func followMouse():
	if get_node("/root/World").mouse_in_build_area:
		var mouse_tile = get_node("/root/World").buildable_tile_map.local_to_map(get_global_mouse_position())
		var local_pos = get_node("/root/World").buildable_tile_map.map_to_local(mouse_tile)
		global_position = get_node("/root/World").buildable_tile_map.to_global(local_pos)
	else:
		global_position = get_global_mouse_position() + Vector2(1, 1)

func _on_drag_box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			MouseSelected = true
		elif get_node("/root/World").mouse_in_build_area:
			MouseSelected = false
