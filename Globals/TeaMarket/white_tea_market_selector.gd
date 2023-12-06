extends MarginContainer

signal recipe_selected

@onready var texture_rect = $MarginContainer2/TextureRect
@export var recipe_item: ItemData
@onready var button = $Button
@onready var label = $MarginContainer/Label


func _on_button_pressed():
	emit_signal("recipe_selected", recipe_item)

func set_container_data(item_data) -> void:
	recipe_item = item_data
	texture_rect.texture = recipe_item.texture
	label.text = recipe_item.name
	button.pressed.connect(_on_button_pressed)
	
	#if slot_data.finished_item_data:
		#var item_data = slot_data.finished_item_data
		#texture_rect.texture = item_data.texture
		#label.text = str(str(item_data.name) + "\nBase Value: " + str(item_data.base_value))
		#tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	#if recipe_item.quantity <= 0:
		#button.disabled = true
	#else:
		#button.disabled = false
	
	if not is_instance_valid(recipe_item):
		return
