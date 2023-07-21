extends MarginContainer

signal recipe_selected

@onready var texture_rect = $MarginContainer2/TextureRect
@export var recipe_item: ItemData
@onready var button = $Button
@onready var label = $MarginContainer/Label

func _ready():
	texture_rect.texture = recipe_item.texture
	label.text = recipe_item.name
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("recipe_selected", recipe_item)
