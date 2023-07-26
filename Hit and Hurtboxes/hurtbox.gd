extends Area2D

@export var harvestable = true
@onready var collisionShape = $CollisionShape2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal player_interact
signal invincibility_started
signal invincibility_ended
@onready var timer = $Timer
@onready var invincible = false:
	get:
		return invincible
	set(value):
		invincible = value
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func create_hit_effect():
		var hitEffect = HitEffect.instantiate()
		get_parent().add_child(hitEffect)
		hitEffect.global_position = global_position

func _on_timer_timeout():
	self.invincible = false

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_invincibility_ended():
	collisionShape.set_deferred("disabled", false)

func player_interact_area():
	emit_signal("player_interact")
