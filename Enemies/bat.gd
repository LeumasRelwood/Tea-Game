extends CharacterBody2D

const DeathEffect = preload("res://Effects/death_effect.tscn")
@onready var playerdetectionzone = $PlayerDetectionZone
@onready var animatedSpriteBat = $AnimatedSpriteBat
@onready var stats = $Stats
var knockbackvector = Vector2.ZERO
@export var knockbackamount = 200
@export var acceleration = 15
@export var max_speed = 75
@export var friction = 15

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	animatedSpriteBat.frame = 0
	animatedSpriteBat.play("Flying")

func _physics_process(delta):
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 15)
			seek_player()
		
		WANDER:
			pass
			
		CHASE:
			var player = playerdetectionzone.player
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * max_speed, acceleration)
			else:
				state = IDLE
			animatedSpriteBat.flip_h = velocity.x < 0
	
	move_and_slide()
	
func seek_player():
	if playerdetectionzone.can_see_player():
		state = CHASE
	
func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockbackvector = area.knockback_vector
	velocity = knockbackvector * knockbackamount
	
func _on_stats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
