extends MarginContainer

signal recipe_selected

@onready var texture_rect = $MarginContainer3/MarginContainer2/TextureRect
@export var recipe_item: ItemData

func _ready():
	texture_rect.texture = recipe_item.texture

func _on_button_pressed():
	emit_signal("recipe_selected", recipe_item)
