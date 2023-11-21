extends MarginContainer

signal item_selected

@onready var texture_rect = $MarginContainer3/MarginContainer2/TextureRect
@export var shop_item: SlotData
@onready var button = $Button
@onready var label = $MarginContainer/Label

func set_container_data(slot_data: SlotData) -> void:
	shop_item = slot_data
	if slot_data.item_data:
		var item_data = slot_data.item_data
		texture_rect.texture = item_data.texture
		label.text = str(str(shop_item.item_data.name) + "\nCost: " + str(shop_item.item_data.base_value) + ", Qty: " + str(shop_item.quantity))
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	button.pressed.connect(_on_button_pressed)
	if shop_item.quantity <= 0:
		button.disabled = true
	else:
		button.disabled = false
	
	if not is_instance_valid(slot_data):
		return

func _on_button_pressed():
	emit_signal("item_selected", shop_item)

#func _on_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton \
			#and (event.button_index == MOUSE_BUTTON_LEFT \
			#or event.button_index == MOUSE_BUTTON_RIGHT) \
			#and event.is_pressed():
		#item_selected.emit(get_index(), event.button_index)
