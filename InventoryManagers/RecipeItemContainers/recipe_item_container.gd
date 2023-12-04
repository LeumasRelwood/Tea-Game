extends MarginContainer

signal recipe_selected

@onready var texture_rect = $MarginContainer3/MarginContainer2/TextureRect
@export var recipe_item: TeaRecipeData
@onready var button = $Button
@onready var label = $MarginContainer/Label

#func _ready():
	#texture_rect.texture = recipe_item.item_data.texture
	#button.pressed.connect(_on_button_pressed)
	#label.text = str(str(recipe_item.item_data.name) + "\nBase Value: " + str(recipe_item.item_data.base_value))

func set_container_data(slot_data: TeaRecipeData) -> void:
	recipe_item = slot_data
	if slot_data.finished_item_data:
		var item_data = slot_data.finished_item_data
		texture_rect.texture = item_data.texture
		label.text = str(str(item_data.name) + "\nBase Value: " + str(item_data.base_value))
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	button.pressed.connect(_on_button_pressed)
	#if recipe_item.quantity <= 0:
		#button.disabled = true
	#else:
		#button.disabled = false
	
	if not is_instance_valid(slot_data):
		return

func _on_button_pressed():
	emit_signal("recipe_selected", recipe_item.next_item_data)

#func _on_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton \
			#and (event.button_index == MOUSE_BUTTON_LEFT \
			#or event.button_index == MOUSE_BUTTON_RIGHT) \
			#and event.is_pressed():
		#item_selected.emit(get_index(), event.button_index)
