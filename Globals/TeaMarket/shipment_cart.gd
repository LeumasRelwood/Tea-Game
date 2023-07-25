extends CharacterBody2D

var direction = Vector2.ZERO
var distance
var shipment_value
var shipment_quantity
var shipment_item
var destination
@export var speed = 1

@onready var tooltip = $Tooltip
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	move_and_slide()
	if position.distance_to(destination.location) < 8:
		shipment_arrived()

func deliver_shipment(city, item, quantity, value, _speed):
	speed = _speed
	shipment_value = value
	shipment_quantity = quantity
	shipment_item = item
	destination = city
	set_tooltip()
	
	direction = position.direction_to(city.location)
	distance = position.distance_to(city.location)
	velocity = direction * speed
	
	look_at(city.location)
	if rotation > -90 and rotation < 90:
		sprite_2d.flip_v = true

func set_tooltip():
	tooltip.tooltip_text = str("Destination: " + str(destination.city_name) + "\n" + str(shipment_item.name) + "\nQty: " + str(shipment_quantity) + ", Value: " + str(shipment_value))

func shipment_arrived():
	PlayerStats.coins += shipment_value
	print(PlayerStats.coins)
	call_deferred("queue_free")

func toggle_visibility():
	visible = not visible
