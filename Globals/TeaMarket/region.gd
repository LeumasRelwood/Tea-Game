extends Node

signal add_buy_offer(buy_offers: Array[BuyOffer], city_name)

@export var city_name: String
@export var population: int
@export var wealth: int
@export var fertility: int
@export var tea_culture: int
@export var location: Vector2
@export var selling_range: int

@export var demand: int
@export var available_money: int

@export var inventory: Array[SlotData]
@export var buy_offers: Array[BuyOffer]

var buy_inventory_spot = -1

func _ready():
	available_money = population * wealth
	demand = population * tea_culture * wealth
	
func market_update():
	make_buy_offers()

func make_buy_offers():
	for index in buy_offers:
		buy_inventory_spot += 1
		index.item_data = inventory[buy_inventory_spot].item_data
		index.quantity = randi_range(demand*0.75, demand*2)
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		index.region = city_name
	add_buy_offer.emit(buy_offers, city_name)
	print(buy_offers[0].quantity)
	buy_inventory_spot = -1

