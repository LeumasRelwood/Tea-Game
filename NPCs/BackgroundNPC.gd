extends CharacterBody2D

const PlayerHurtSound = preload("res://Music and Sounds/player_hurt_sound.tscn")
const DeathEffect = preload("res://Effects/death_effect.tscn")
const Ballon = preload("res://Dialogues/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@export var MAX_SPEED = 10
@export var ACCELERATION = 15
@export var FRICTION = 15
@export var ROLL_SPEED = 100
var knockbackvector = Vector2.ZERO
@export var knockbackamount = 300

enum {
	IDLE,
	WANDER,
	TALKING
}

var state = IDLE
var roll_vector = Vector2.DOWN
var onStair = 0
var StairFactor = Vector2.ZERO
var StairAngle = Vector2.ZERO
var input_vector = Vector2.ZERO

@onready var global = get_node("/root/Global")
@onready var animation_player = $AnimationPlayer
@onready var blink_animation_player = $BlinkAnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var player_interact_area = $"Hitbox pivot/PlayerInteractArea"
@onready var swordhitboxcollision = $"Hitbox pivot/SwordHitbox/CollisionShape2D"
@onready var StairSensor = $StairSensor
@onready var wanderController = $WanderController
@onready var stats = $Stats

func _ready():
	animation_tree.active = true
	player_interact_area.knockback_vector = roll_vector
	check_for_state()

func _physics_process(_delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
			animation_state.travel("Idle")
			check_for_state()
		WANDER:
			wander_state()
			check_for_state()
		TALKING:
			animation_state.travel("Idle")


func check_for_state():
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(randi_range(1, 2))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func wander_state():
	var direction = global_position.direction_to(wanderController.target_position)
	input_vector = direction
	
	if global_position.distance_to(wanderController.target_position) <= MAX_SPEED / 25:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	#print(velocity)
	
	if onStair:
		if velocity.x > 0:
			StairFactor = abs(StairAngle) * -1
		elif velocity.x < 0:
			StairFactor = abs(StairAngle)
		else:
			StairFactor = Vector2.ZERO
	
	input_vector += StairFactor
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		player_interact_area.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_tree.set("parameters/Interact/blend_position", input_vector)
		animation_state.travel("Run")
		velocity += input_vector * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	move_and_slide()

func _on_player_interact_area_area_entered(area):
	area.player_interact_area()

func _on_stair_sensor_area_entered(area):
	onStair = true
	StairAngle = area.StairAngle

func _on_stair_sensor_area_exited(area):
	onStair = false
	StairFactor = Vector2.ZERO

func _on_hurtbox_area_entered(area):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	var direction = global_position.direction_to(area.get_parent().get_parent().global_position)
	animation_tree.set("parameters/Idle/blend_position", direction)
	
	var balloon: Node = Ballon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
	
	state = TALKING

func conversation_finished():
	check_for_state()

func _on_stats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
func _on_hurtbox_invincibility_started():
	blink_animation_player.play("Start")
func _on_hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
