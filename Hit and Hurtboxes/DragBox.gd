extends Node2D

var MouseSelected = false
var mouse_offset = Vector2.ZERO

func _process(delta):
	if MouseSelected:
		followMouse()
		
func followMouse():
	position = get_global_mouse_position() + mouse_offset

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			MouseSelected = true
		else:
			MouseSelected = false
