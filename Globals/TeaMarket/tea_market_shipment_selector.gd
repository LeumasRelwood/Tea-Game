extends MarginContainer

signal recipe_selected(_buy_offer)

@onready var texture_rect = $MarginContainer2/TextureRect
@export var recipe_item: ItemData
@onready var button = $Button
@onready var label = $MarginContainer/MarginContainer/Label
@onready var label_2 = $MarginContainer/MarginContainer2/Label2

var _buy_offer

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("recipe_selected", _buy_offer)

func set_selector_info(buy_offer):
	texture_rect.texture = buy_offer.item_data.texture
	label.text = buy_offer.item_data.name
	label_2.text = str("Price: " + str(buy_offer.asking_price) + ", Qty: " + str(buy_offer.quantity))
	_buy_offer = buy_offer
