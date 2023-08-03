extends StaticBody2D

@export var slot_data: SlotData
@export var growth_time: float
@onready var sprite2d = $Sprite2D
@onready var ShadowSprite = $ShadowSprite
@onready var HarvestableArea2D = $HarvestableArea2D
@onready var CollisionShape = $CollisionShape2D
@onready var global = get_node("/root/Global")
@onready var sprite_2d = $Sprite2D
var rng = RandomNumberGenerator.new()
var MouseSelected = false
var mouse_offset = Vector2.ZERO
var growthprogress: float = 0
var numberofstages = 4
var growthcomplete
var growthstage = 1
@export var planted_time_minutes: int
 
func _ready():
	pass

func planted():
	planted_time_minutes = global.total_minutes
	growthcomplete = global.total_minutes + (growth_time * 60)
	
	var shader_offset = rng.randf_range(0.0, 15)
	var shader_speed = rng.randf_range(0.03, 0.05)
	sprite_2d.material.set("shader_param/offset", shader_offset)
	sprite_2d.material.set("shader_param/speed", shader_speed)

func _process(delta):
	if growthprogress >= 100:
		HarvestableArea2D.harvestable = true
		CollisionShape.scale = Vector2(1,1)
		sprite2d.scale = Vector2(1,1)
		ShadowSprite.scale = Vector2(1,1)
	else:
		HarvestableArea2D.harvestable = false
		growthprogress = clamp((((global.total_minutes - planted_time_minutes) / (growth_time * 60)) * 100), 1, 100)
		growthstage = clamp(snapped(growthprogress, 100 / numberofstages) / (100 / numberofstages), 1, numberofstages)
		
		CollisionShape.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / 100)
		sprite2d.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / 100)
		ShadowSprite.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / 100)
		
	if MouseSelected:
		followMouse()

func followMouse():
	if get_node("/root/World").mouse_in_build_area:
		var mouse_tile = get_node("/root/World").buildable_tile_map.local_to_map(get_global_mouse_position())
		var local_pos = get_node("/root/World").buildable_tile_map.map_to_local(mouse_tile)
		global_position = get_node("/root/World").buildable_tile_map.to_global(local_pos)
	else:
		global_position = get_global_mouse_position() + Vector2(1, 1)

func _on_area_2d_area_entered(area):
	if HarvestableArea2D.harvestable:
		harvest_bush(area)
	else:
		pass

func harvest_bush(area):
	if area.inventory_data.pick_up_slot_data(slot_data):
		growthprogress = 0
		growthstage = 1
		planted_time_minutes = global.total_minutes
		sprite2d.scale = Vector2(0.5, 0.5)
		ShadowSprite.scale = Vector2(0.5, 0.5)
		CollisionShape.scale = Vector2(0.5, 0.5)

func _on_drag_box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			MouseSelected = true
		elif get_node("/root/World").mouse_in_build_area:
			MouseSelected = false
