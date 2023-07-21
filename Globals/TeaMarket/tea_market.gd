extends Node


@onready var highest_price = $PanelContainer/MarginContainer4/MarginContainer/HighestPrice
@onready var avg_price = $PanelContainer/MarginContainer4/MarginContainer2/AvgPrice
@onready var lowest_price = $PanelContainer/MarginContainer4/MarginContainer3/LowestPrice
@export var selected_item: ItemData
@export var tea_market: Array[CommodityMarket]

var selected_city

const Commodity_Market = preload("res://Globals/Economy/commodity_market.gd")
const Regional_Offer = preload("res://Globals/TeaMarket/regional_offers.gd")

func _ready():
	for node in get_tree().get_nodes_in_group("regions"):
		node.add_buy_offer.connect(add_buy_offer)
		node.city_selected.connect(city_selected)
	
	for node in get_tree().get_nodes_in_group("teamarket_selectors"):
		node.recipe_selected.connect(recipe_item_selected)
	
	market_update()

func _physics_process(delta):
	if Input.is_action_just_pressed("MarketUpdateTest"):
		market_update()

func market_update():
	for offers in tea_market:
		offers.buy_offers.clear()
	
	get_tree().call_group("regions", "market_update")

func add_buy_offer(index):
	for commodity in tea_market:
		if index.item_data == commodity.item_data:
			commodity.buy_offers.append(index)
	
	refresh_interface()

func refresh_interface():
	var displayed_item: ItemData = selected_item
	var sum: float
	var avg: float
	var high: float
	var low: float
	for index in tea_market:
		if index.item_data == displayed_item:
			high = 0
			low = 999999
			for offer in index.buy_offers:
				sum += offer.asking_price
				avg = sum/index.buy_offers.size()
				if offer.asking_price > high:
					high = offer.asking_price
				if offer.asking_price < low:
					low = offer.asking_price
			highest_price.text = str("Highest Price: " + str(high))
			avg_price.text = str("Avg Price: " + str(avg))
			lowest_price.text = str("Lowest Price: " + str(low))
	
	get_tree().call_group("regions", "display_buy_offer", selected_item)

func recipe_item_selected(_selected_item):
	selected_item = _selected_item
	refresh_interface()

func _on_show_preferred_toggled(button_pressed):
	get_tree().call_group("regions", "toggle_display_preferred")

func city_selected(city_name):
	selected_city = city_name
	get_tree().call_group("regions", "selected_city", selected_city)
