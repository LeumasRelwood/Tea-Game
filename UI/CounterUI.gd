extends Control

@onready var Clock = $Clock
@onready var global = get_node("/root/Global")
@onready var stats = get_node("/root/PlayerStats")

func _ready():
	global.time_changed.connect(set_time)

func set_time(value):
	Clock.text = ("minute " + str(global.minute) + " hour " + str(global.hour) + " day " + str(global.day))
