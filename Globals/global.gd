extends Node2D

signal time_changed(value)

@export var initial_hour = 14
@export var time_multiplier = 20

var total_minutes = 0
var minute = 0
var hour = 0
var day = 1
var month = 1
var year = 1
var canvas_value: float
var time_of_day: float
var displaytime = 0.0
var time = 0:
	set(value):
		time = value
		emit_signal("time_changed", minute, hour, day, month, year)

const hours_per_day: float = 24
const minutes_per_hour: float = 60

func _ready():
	randomize()
	hour = initial_hour

func _process(delta):
	time += delta * time_multiplier
	displaytime += delta * time_multiplier
	if displaytime >= 1.0:
		displaytime -= 1.0
		minute += 1
		total_minutes += 1
		if minute == 60:
			minute = 0
			hour += 1
			if hour == 24:
				hour = 0
				day += 1
				if day == 31:
					day = 1
					month += 1
					if month == 13:
						month = 1
						year += 1
	
	if hour >= 7 and hour < 17:
		get_tree().call_group("lights", "turn_off")
	if hour >= 17 or hour < 7:
		get_tree().call_group("lights", "turn_on")
		
	#if day_minutes == 1440:
		#day_minutes = 0
	
	time_of_day = (hour / hours_per_day * 2) + (minute / minutes_per_hour / hours_per_day * 2)
	
	if time_of_day <= 1:
		canvas_value = time_of_day
	if time_of_day > 1:
		canvas_value = 1 - (time_of_day-1)
	
	get_tree().call_group("DayNightModulator", "update_canvas", canvas_value)
