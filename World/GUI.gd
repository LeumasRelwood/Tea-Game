extends Control

@onready var Clock = $Clock
@onready var TeaCounter = $TeaCounter
@onready var global = get_node("/root/Global")

func _process(delta):
	Clock.text = ("minute " + str(global.minute) + " hour " + str(global.hour) + " day " + str(global.day))
	TeaCounter.text = (str(global.tealeaves) + "Kgs of tea")
