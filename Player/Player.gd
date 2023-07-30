extends CharacterBody2D

const PlayerHurtSound = preload("res://Music and Sounds/player_hurt_sound.tscn")

@export var MAX_SPEED = 100
@export var ACCELERATION = 15
@export var FRICTION = 15
@export var ROLL_SPEED = 100

signal toggle_tea_market
signal toggle_inventory

enum {
	MOVE,
	ROLL,
	ATTACK,
	TALKING
}

var state = MOVE
var roll_vector = Vector2.DOWN
var onStair = 0
var StairFactor = Vector2.ZERO
var StairAngle = Vector2.ZERO
var input_vector = Vector2.ZERO

@onready var global = get_node("/root/Global")
@onready var playerstats = get_node("/root/PlayerStats")
@onready var animation_player = $AnimationPlayer
@onready var blink_animation_player = $BlinkAnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var player_interact_area = $"Hitbox pivot/PlayerInteractArea"
@onready var swordhitboxcollision = $"Hitbox pivot/SwordHitbox/CollisionShape2D"
@onready var StairSensor = $StairSensor
@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

func _ready():
	animation_tree.active = true
	player_interact_area.knockback_vector = roll_vector
	player_interact_area.conversation_start.connect(conversation_started)
	player_interact_area.conversation_finish.connect(conversation_finished)
	playerstats.no_health.connect(queue_free)
	playerstats.player = self

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		TALKING:
			pass


func move_state():
	if onStair:
		if Input.is_action_pressed("ui_right"):
			StairFactor = abs(StairAngle) * -1
		elif Input.is_action_pressed("ui_left"):
			StairFactor = abs(StairAngle)
		else:
			StairFactor = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
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
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("Roll") and input_vector != Vector2.ZERO:
		state = ROLL
	
	if Input.is_action_just_pressed("Interact"):
		animation_state.travel("Interact")
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("TeaMarket"):
		toggle_tea_market.emit()

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move_and_slide()
	animation_state.travel("Roll")
	
func roll_animation_finished():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	state = MOVE

func attack_state():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	move_and_slide()
	animation_state.travel("Attack")

func _on_player_interact_area_area_entered(area):
	area.player_interact_area()
	
func attack_animation_finished():
	state = MOVE



func _on_stair_sensor_area_entered(area):
	onStair = true
	StairAngle = area.StairAngle

func _on_stair_sensor_area_exited(area):
	onStair = false
	StairFactor = Vector2.ZERO

func heal(heal_value: int) -> void:
	if playerstats.health < playerstats.max_health:
		playerstats.health += heal_value

func _on_hurtbox_area_entered(area):
	playerstats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_hurtbox_invincibility_started():
	blink_animation_player.play("Start")

func _on_hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")

func conversation_started():
	state = TALKING

func conversation_finished():
	await get_tree().process_frame
	state = MOVE
