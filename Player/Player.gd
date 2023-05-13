extends CharacterBody2D

const bush = preload("res://World/bush.tscn")

@export var MAX_SPEED = 100
@export var ACCELERATION = 15
@export var FRICTION = 15
@export var ROLL_SPEED = 100

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN
var onStair = 0
var StairFactor = Vector2.ZERO
var StairAngle = Vector2.ZERO
var input_vector = Vector2.ZERO

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var swordHitBox = $"Hitbox pivot/SwordHitbox"
@onready var swordhitboxcollision = $"Hitbox pivot/SwordHitbox/CollisionShape2D"
@onready var TeaInventory = 0
@onready var StairSensor = $StairSensor

func _ready():
	animation_tree.active=true
	swordHitBox.knockback_vector = roll_vector
	print("Stair Factor is " + str(StairFactor))

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()


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
		swordHitBox.knockback_vector = input_vector
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
		
	if Input.is_action_just_pressed("Plant"):
		plant_bush()


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
	
func _on_sword_hitbox_area_entered(area):
	var harvestable = area.harvestable
	if harvestable:
		harvest_bush()
	
func attack_animation_finished():
	state = MOVE
	
	

func plant_bush():
	var Bush = bush.instantiate()
	get_parent().add_child(Bush)
	Bush.global_position = (global_position + input_vector)





func harvest_bush():
	TeaInventory += 1
	print("You have " + str(TeaInventory) + "Kgs of tea.")





func _on_stair_sensor_area_entered(area):
	onStair = true
	StairAngle = area.StairAngle

func _on_stair_sensor_area_exited(area):
	onStair = false
	StairFactor = Vector2.ZERO


