extends CharacterBody2D

const DeathEffect = preload("res://Effects/death_effect.tscn")
@onready var playerdetectionzone = $PlayerDetectionZone
@onready var sprite = $AnimatedSpriteBat
@onready var hurtbox = $Hurtbox
@onready var stats = $Stats
@onready var SoftCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer
var knockbackvector = Vector2.ZERO
@export var knockbackamount = 300
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
	randomize()
	sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count("Flying")-1)
	sprite.play("Flying")
	check_for_state()

func _physics_process(delta):
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction)
			seek_player()
			check_for_state()
			
		WANDER:
			seek_player()
			check_for_state()
			move_towards_point(wanderController.target_position)
			if global_position.distance_to(wanderController.target_position) <= max_speed / 25:
				velocity = velocity.move_toward(Vector2.ZERO, friction)
			
		CHASE:
			var player = playerdetectionzone.player
			if player != null:
				move_towards_point(player.global_position)
			else:
				state = IDLE
	
	if SoftCollision.is_colliding():
		velocity += SoftCollision.get_push_vector() * 15
	
	sprite.flip_h = velocity.x < 0
	move_and_slide()

func move_towards_point(point):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration)

func seek_player():
	if playerdetectionzone.can_see_player():
		state = CHASE

func check_for_state():
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(randi_range(1, 2))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockbackvector = area.knockback_vector
	velocity = knockbackvector * knockbackamount
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
func _on_stats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
