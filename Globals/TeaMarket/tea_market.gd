extends Node

const shipment_selector = preload("res://Globals/TeaMarket/tea_market_shipment_selector.tscn")

@onready var highest_price = $PanelContainer/MarginContainer4/MarginContainer/HighestPrice
@onready var avg_price = $PanelContainer/MarginContainer4/MarginContainer2/AvgPrice
@onready var lowest_price = $PanelContainer/MarginContainer4/MarginContainer3/LowestPrice
@export var selected_item: ItemData
@export var tea_market: Array[CommodityMarket]
@export var available_shipments = 3

@onready var shipments = $PanelContainer/MarginContainer6/MarginContainer/Shipments
@onready var city_name = $PanelContainer2/MarginContainer2/CityName
@onready var shipping_time = $PanelContainer2/MarginContainer4/ShippingTime
@onready var qty_to_sell = $PanelContainer2/MarginContainer3/MarginContainer/QtyToSell
@onready var h_slider = $PanelContainer2/MarginContainer3/MarginContainer2/HSlider
@onready var v_box_container = $PanelContainer2/MarginContainer5/ScrollContainer/MarginContainer4/VBoxContainer
@onready var send_order = $PanelContainer2/MarginContainer/SendOrder

@onready var panel_container_2 = $PanelContainer2

var selected_city
var selected_offer
var quantity_to_sell

const Commodity_Market = preload("res://Globals/Economy/commodity_market.gd")
const Regional_Offer = preload("res://Globals/TeaMarket/regional_offers.gd")

func _ready():
	if not selected_city:
		panel_container_2.visible = false
	
	for node in get_tree().get_nodes_in_group("regions"):
		node.add_buy_offer.connect(add_buy_offer)
		node.city_selected.connect(city_selected)
	
	for node in get_tree().get_nodes_in_group("teamarket_selectors"):
		node.recipe_selected.connect(recipe_item_selected)
	
	shipments.text = str("Available Shipments: " + str(available_shipments))
	
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

func city_selected(city):
	selected_city = city
	if selected_city:
		panel_container_2.visible = true
	city_name.text = city.city_name
	shipping_time.text = str("Shipping Time: " + str(city.shipment_time_hours) + " hours")
	get_tree().call_group("regions", "selected_city", selected_city)
	populate_shipment_options(city)
	
	for buy_offer in city.buy_offers:
		if buy_offer.item_data == selected_item:
			shipment_item_selected(buy_offer)

func populate_shipment_options(city):
	for child in v_box_container.get_children():
		child.queue_free()
	
	for buy_offer in city.buy_offers:
		var selector = shipment_selector.instantiate()
		v_box_container.add_child(selector)
		selector.set_selector_info(buy_offer)
		selector.recipe_selected.connect(shipment_item_selected)

func shipment_item_selected(buy_offer):
	var inventory_total: int
	for slot_data in GlobalTeaStorage.tea_storage_inventory_data.slot_datas:
		if slot_data:
			if slot_data.item_data == buy_offer.item_data:
				inventory_total += slot_data.quantity
	
	selected_offer = buy_offer
	h_slider.max_value = clamp(buy_offer.quantity, 0, inventory_total)
	quantity_to_sell = h_slider.max_value
	h_slider.value = quantity_to_sell
	set_qty_to_sell()

func _on_h_slider_value_changed(value):
	quantity_to_sell = h_slider.value
	set_qty_to_sell()

func set_qty_to_sell():
	qty_to_sell.text = str("Qty. to Sell: " + str(quantity_to_sell))

func _on_send_order_pressed():
	if quantity_to_sell > 0:
		for buy_offer in selected_city.buy_offers:
			if buy_offer.item_data == selected_offer.item_data:
				buy_offer.quantity -= quantity_to_sell
				selected_city.display_buy_offer(buy_offer.item_data)
		
		for slot_data in GlobalTeaStorage.tea_storage_inventory_data.slot_datas:
			if slot_data:
				if slot_data.item_data == selected_offer.item_data:
					var quantity_sold = clamp(quantity_to_sell, 0, slot_data.quantity)
					slot_data.quantity -= quantity_sold
					quantity_to_sell -= quantity_sold
		
		shipment_item_selected(selected_offer)
		populate_shipment_options(selected_city)
		#GlobalTeaStorage.relay_global_tea_storage()

		available_shipments -= 1
		shipments.text = str("Available Shipments: " + str(available_shipments))
