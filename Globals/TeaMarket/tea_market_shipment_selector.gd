extends MarginContainer

signal recipe_selected(_buy_offer)

@onready var texture_rect = $MarginContainer2/TextureRect
@export var recipe_item: ItemData
@onready var button = $Button
@onready var label = $MarginContainer/MarginContainer/Label
@onready var label_2 = $MarginContainer/MarginContainer2/Label2

var _buy_offer

func set_selector_info(buy_offer) -> void:
	recipe_item = buy_offer.item_data
	
	texture_rect.texture = recipe_item.texture
	label.text = recipe_item.name
	label_2.text = str("Price: " + str(buy_offer.asking_price) + ", Qty: " + str(buy_offer.quantity))
	_buy_offer = buy_offer
	
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
	
	if not is_instance_valid(buy_offer):
		return


func _on_button_pressed():
	emit_signal("recipe_selected", _buy_offer)

#func _ready():
	#texture_rect.texture = recipe_item.item_data.texture
	#button.pressed.connect(_on_button_pressed)
	#label.text = str(str(recipe_item.item_data.name) + "\nBase Value: " + str(recipe_item.item_data.base_value))
