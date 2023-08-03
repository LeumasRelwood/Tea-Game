extends Area2D

signal change_map(current_map_path, next_map_path, player_position)


@export var current_map_name: String
@export var next_map_name: String
@export var player_position: Vector2
var current_map_path: String
var next_map_path: String

func _ready():
	current_map_path = str("res://SavedGames/SavedMaps/" + str(current_map_name) + ".tscn")
	next_map_path = str("res://SavedGames/SavedMaps/" + str(next_map_name) + ".tscn")

func _on_area_entered(area):
	if area.has_method("player"):
		emit_signal("change_map",current_map_path, next_map_path, player_position)
