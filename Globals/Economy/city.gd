extends Node

@onready var producer = $Producer
@onready var merchant = $Merchant
@onready var consumer = $Consumer

@export var city_name: String
@export var population: int
@export var wealth: int
@export var fertility: int
@export var tea_culture: int
@export var location: Vector2
@export var selling_range: int

func _ready():
	producer.production_capacity = population * fertility
	merchant.available_money = population * wealth
	consumer.available_money = population * wealth
	consumer.base_desire = population * tea_culture

func market_update():
	producer.market_update()
	merchant.market_update()
	consumer.market_update()
