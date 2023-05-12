extends CharacterBody2D

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
var StairFactor = Vector2.ZERO

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var swordHitBox = $"Hitbox pivot/SwordHitbox"
@onready var TeaInventory = 0
@onready var harvestcollision = $HarvestArea2D/CollisionShape2D
@onready var StairSensor = $StairSensor

func _ready():
	animation_tree.active=true
	swordHitBox.knockback_vector = roll_vector
	harvestcollision.disabled = true

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
			

func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.y += StairFactor
	input_vector = input_vector.normalized()
	harvestcollision.disabled = true
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitBox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
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
	harvestcollision.disabled = false
	
	
func attack_animation_finished():
	state = MOVE
	
	

	
	



func _on_harvest_area_2d_area_entered(area):
	if area.harvestable != 0:
		harvest_bush()

func harvest_bush():
	TeaInventory += 1
	print("You have " + str(TeaInventory) + "Kgs of tea.")




func _on_stair_sensor_area_entered(area):
	if Input.is_action_pressed("ui_right"):
		StairFactor.y = area.StairFactor.y
	elif Input.is_action_pressed("ui_left"):
		StairFactor.y = area.StairFactor.y * -1
	print(StairFactor)


func _on_stair_sensor_area_exited(area):
	StairFactor = Vector2.ZERO
