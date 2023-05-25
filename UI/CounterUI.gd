extends Control

@onready var Clock = $Clock
@onready var TeaCounter = $TeaCounter
@onready var global = get_node("/root/Global")
@onready var stats = get_node("/root/PlayerStats")

func _ready():
	stats.tealeaves_changed.connect(set_tealeaves)
	global.time_changed.connect(set_time)

func set_tealeaves(value):
	TeaCounter.text = (str(stats.tealeaves) + "Kgs of tea")

func set_time(value):
	Clock.text = ("minute " + str(global.minute) + " hour " + str(global.hour) + " day " + str(global.day))
