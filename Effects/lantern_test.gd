extends StaticBody2D
@onready var point_light_2d = $PointLight2D

@export var size : int = 340
@export var flicker: Noise
@onready var noise = FastNoiseLite.new()
var value = 0.0
const MAX_VALUE = 100000000

func _ready():
	randomize()
	value = randi() % MAX_VALUE
	noise.frequency = 16

func _physics_process(delta):
	value += 0.5
	if (value > MAX_VALUE):
		value = 0.0
	var energy = ((flicker.get_noise_1d(value) + 1) / 4.0) + 0.5
	point_light_2d.energy = energy
	point_light_2d.texture.width = energy * size
	point_light_2d.texture.height = point_light_2d.texture.width

func turn_off():
	point_light_2d.visible = false

func turn_on():
	point_light_2d.visible = true
