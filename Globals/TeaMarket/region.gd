extends Node

signal add_buy_offer(index)
signal city_selected(city_name)

@onready var product_info = $MarginContainer/ProductInfo
@onready var preffered_product_image = $MarginContainer2/PrefferedProductImage
@onready var preffered_product_label = $MarginContainer2/PrefferedProductLabel
@onready var margin_container_2 = $MarginContainer2
@onready var texture_rect = $MarginContainer4/MarginContainer3/TextureRect

@export var city_name: String
@export var preffered_product: ItemData
@export var population: int
@export var wealth: int
@export var fertility: int
@export var tea_culture: int
@export var location: Vector2
@export var selling_range: int

var map_selected = false
var selected_item
var demand: int
var available_money: int

@export var inventory: Array[SlotData]
@export var buy_offers: Array[BuyOffer]

var buy_inventory_spot = -1

func _ready():
	available_money = population * wealth
	demand = population * tea_culture * wealth
	preffered_product_image.texture = preffered_product.texture
	preffered_product_label.text = preffered_product.name

func market_update():
	make_buy_offers()

func make_buy_offers():
	for index in buy_offers:
		buy_inventory_spot += 1
		index.item_data = inventory[buy_inventory_spot].item_data
		index.quantity = randi_range(demand*0.75, demand*2)
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		if index.item_data == preffered_product:
			index.asking_price = index.asking_price * 1.10
		index.region = city_name
		add_buy_offer.emit(index)
	buy_inventory_spot = -1

func display_buy_offer(item_data):
	for index in buy_offers:
		if index.item_data == item_data:
			product_info.text = ("Price: " + str(index.asking_price) + "  Qty: " + str(index.quantity))

func toggle_display_preferred():
	margin_container_2.visible = not margin_container_2.visible

func selected_city(_city_name):
	if city_name == _city_name:
		map_selected = true
	else: map_selected = false
	
	if map_selected:
		texture_rect.visible = true
	else:
		texture_rect.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		city_selected.emit(city_name)
