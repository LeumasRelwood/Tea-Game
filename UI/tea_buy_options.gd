extends Control

@onready var tea_market = $TeaMarket
@onready var region = $Region
@onready var product = $Region/Product
@onready var product_2 = $Region/Product2
@onready var product_3 = $Region/Product3
@onready var price = $Region/Product/Price
@onready var price_2 = $Region/Product2/Price2
@onready var price_3 = $Region/Product3/Price3
@onready var quantity = $Region/Product/Quantity
@onready var quantity_2 = $Region/Product2/Quantity2
@onready var quantity_3 = $Region/Product3/Quantity3


func _ready():
	tea_market.refresh_interface.connect(refresh_interface)

func refresh_interface():
	region.text = tea_market.tea_market[0].region
	product.text = tea_market.tea_market[0].buy_offers[0].item_data.name
	price.text = str(tea_market.tea_market[0].buy_offers[0].asking_price)
	quantity.text = str(tea_market.tea_market[0].buy_offers[0].quantity)
	product_2.text = tea_market.tea_market[0].buy_offers[1].item_data.name
	price_2.text = str(tea_market.tea_market[0].buy_offers[1].asking_price)
	quantity_2.text = str(tea_market.tea_market[0].buy_offers[1].quantity)
	product_3.text = tea_market.tea_market[0].buy_offers[2].item_data.name
	price_3.text = str(tea_market.tea_market[0].buy_offers[2].asking_price)
	quantity_3.text = str(tea_market.tea_market[0].buy_offers[2].quantity)
