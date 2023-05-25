extends Control

@onready var HeartUIFull = $HeartUIFull
@onready var HeartUIEmpty = $HeartUIEmpty
@onready var Stats = get_node("/root/PlayerStats")
var hearts = 1
var max_hearts = 1

func _ready():
	self.hearts = Stats.health
	self.max_hearts = Stats.max_health
	Stats.health_changed.connect(set_hearts)
	Stats.max_health_changed.connect(set_max_hearts)
	HeartUIFull.size.x = hearts * 15
	HeartUIEmpty.size.x = max_hearts * 15

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	HeartUIFull.size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	HeartUIEmpty.size.x = max_hearts * 15
