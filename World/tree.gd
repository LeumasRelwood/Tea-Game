extends StaticBody2D

@onready var sprite = $Sprite
var rng = RandomNumberGenerator.new()

func _ready():
	var shader_offset = rng.randf_range(0.0, 30)
	var shader_speed = rng.randf_range(0.04, 0.07)
	sprite.material.set("shader_param/offset", shader_offset)
	sprite.material.set("shader_param/speed", shader_speed)
