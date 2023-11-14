extends MarginContainer

signal recipe_selected

@onready var texture_rect = $MarginContainer3/MarginContainer2/TextureRect
@export var shop_item: SlotData
@onready var button = $Button
@onready var label = $MarginContainer/Label

func _ready():
	texture_rect.texture = shop_item.item_data.texture
	button.pressed.connect(_on_button_pressed)
	label.text = str(str(shop_item.item_data.name) + "\nCost: " + str(shop_item.item_data.base_value) + ", Qty: " + str(shop_item.quantity))

func _on_button_pressed():
	emit_signal("item_selected", shop_item)
