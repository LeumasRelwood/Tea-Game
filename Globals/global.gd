extends Node2D

signal time_changed(value)

var time_multiplier = 2
var minute = 1
var hour = 1
var day = 1
var month = 1
var year = 1
var displaytime = 0.0
var time = 0:
	set(value):
		time = value
		emit_signal("time_changed", value)

func _ready():
	randomize()

func _process(delta):
	time += delta * time_multiplier
	displaytime += delta * time_multiplier
	if displaytime >= 1.0:
		displaytime -= 1.0
		minute += 1
		if minute == 61:
			minute = 1
			hour +=1 
			if hour == 25:
				hour = 1
				day += 1
				if day == 31:
					day = 1
					month += 1
					if month == 13:
						month = 1
						year += 1
