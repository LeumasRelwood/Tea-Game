extends StaticBody2D

@onready var sprite2d = $Sprite2D
@onready var ShadowSprite = $ShadowSprite
@onready var HarvestableArea2D = $HarvestableArea2D
@onready var CollisionShape = $CollisionShape2D
@onready var global = get_node("/root/Global")
var MouseSelected = false
var mouse_offset = Vector2.ZERO
var growthprogress = 0
var growthcomplete = 10
var numberofstages = 4
@onready var growthstage = 0:
	get:
		return growthstage
	set(value):
		growthstage = value
		CollisionShape.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / growthcomplete)
		sprite2d.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / growthcomplete)
		ShadowSprite.scale = Vector2(.5, .5).lerp(Vector2(1, 1), growthprogress / growthcomplete)

func _on_area_2d_area_entered(area):
	if HarvestableArea2D.harvestable:
		harvest_bush()
	else:
		pass

func harvest_bush():
	growthprogress = 0
	growthstage = 1
	sprite2d.scale = Vector2(0.5, 0.5)
	ShadowSprite.scale = Vector2(0.5, 0.5)
	CollisionShape.scale = Vector2(0.5, 0.5)



func _process(delta):
	if growthprogress >= growthcomplete:
		HarvestableArea2D.harvestable = true
	else:
		HarvestableArea2D.harvestable = false
		growthprogress += delta * global.time_multiplier
		growthstage = clamp(snapped(growthprogress, growthcomplete / numberofstages) / (growthcomplete / numberofstages), 1, numberofstages)


	if MouseSelected:
		followMouse()

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func _on_drag_box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			MouseSelected = true
		else:
			MouseSelected = false
