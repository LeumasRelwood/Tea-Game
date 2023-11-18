extends Control

var indicator_position
@export var starting_position = 0
@export var finish_position = 72
@onready var texture_rect = $TextureRect

func _ready():
	texture_rect.position.y = 0

func update_canvas(canvas_value):
	texture_rect.position.y = starting_position + (finish_position - starting_position) * canvas_value * -1
