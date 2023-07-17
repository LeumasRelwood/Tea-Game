extends Node

signal refresh_interface()

@export var tea_market: Array[RegionalOffers]
const Regional_Offer = preload("res://Globals/TeaMarket/regional_offers.gd")

func _ready():
	for node in get_tree().get_nodes_in_group("regions"):
		node.add_buy_offer.connect(add_buy_offer)

func _physics_process(delta):
	if Input.is_action_just_pressed("MarketUpdateTest"):
		market_update()

func market_update():
	tea_market.clear()
	for node in get_tree().get_nodes_in_group("regions"):
		node.market_update()

func add_buy_offer(buy_offers, city_name):
	var regional_offer = Regional_Offer.new()
	regional_offer.buy_offers = buy_offers
	regional_offer.region = city_name
	tea_market.append(regional_offer)
	refresh_interface.emit()
	#print(tea_market[0].buy_offers[0].quantity)
