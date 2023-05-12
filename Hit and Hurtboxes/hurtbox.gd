extends Area2D

@export var show_hit = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	if show_hit:
		var hitEffect = HitEffect.instantiate()
		get_parent().add_child(hitEffect)
		hitEffect.global_position = global_position
