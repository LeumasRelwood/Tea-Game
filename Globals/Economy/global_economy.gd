extends Node

@export var wholesale_market: Array[CommodityMarket]
@export var retail_market: Array[CommodityMarket]

func _ready():
	for node in get_tree().get_nodes_in_group("producers"):
		node.wholesale_sale_offer.connect(wholesale_sale_offer)
	for node in get_tree().get_nodes_in_group("merchants"):
		node.wholesale_buy_offer.connect(wholesale_buy_offer)
	for node in get_tree().get_nodes_in_group("merchants"):
		node.retail_sale_offer.connect(retail_sale_offer)
	for node in get_tree().get_nodes_in_group("consumers"):
		node.retail_buy_offer.connect(retail_buy_offer)

func market_update():
	
	for commodity in wholesale_market:
		commodity.sell_offers.clear()
		commodity.buy_offers.clear()
		
	for commodity in retail_market:
		commodity.sell_offers.clear()
		commodity.buy_offers.clear()
		
	for node in get_tree().get_nodes_in_group("cities"):
		node.market_update()

func _physics_process(delta):
	if Input.is_action_just_pressed("MarketUpdateTest"):
		market_update()

func wholesale_sale_offer(sell_offer):
	for commodity in wholesale_market:
		if commodity.item_data == sell_offer.item_data:
			commodity.sell_offers.append(sell_offer)
			print(str(sell_offer.item_data.name) + str(sell_offer.asking_price))

func wholesale_buy_offer(buy_offer):
	for commodity in wholesale_market:
		if commodity.item_data == buy_offer.item_data:
			commodity.buy_offers.append(buy_offer)

func retail_sale_offer(sell_offer):
	for commodity in wholesale_market:
		if commodity.item_data == sell_offer.item_data:
			commodity.sell_offers.append(sell_offer)

func retail_buy_offer(buy_offer):
	for commodity in retail_market:
		if commodity.item_data == buy_offer.item_data:
			commodity.buy_offers.append(buy_offer)
