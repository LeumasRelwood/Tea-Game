extends Control

@onready var Clock = $Clock
@onready var global = get_node("/root/Global")
@onready var stats = get_node("/root/PlayerStats")

func _ready():
	global.time_changed.connect(set_time)

func set_time(minute, hour, day, month, year):
	Clock.text = ("minute " + str(minute) + " hour " + str(hour) + " day " + str(day))
