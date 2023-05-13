extends StaticBody2D

@onready var sprite2d = $Sprite2D
@onready var HarvestableArea2D = $HarvestableArea2D
@onready var CollisionShape = $CollisionShape2D
var MouseSelected = false
var mouse_offset = Vector2.ZERO

func _on_area_2d_area_entered(area):
	if HarvestableArea2D.harvestable:
		harvest_bush()
	else:
		pass

func harvest_bush():
	sprite2d.scale = Vector2(0.5, 0.5)
	CollisionShape.scale = Vector2(0.5, 0.5)





func _process(delta):
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
