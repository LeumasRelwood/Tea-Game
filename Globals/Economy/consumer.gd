extends Node

signal retail_buy_offer(buy_offer: BuyOffer)

@export var inventory: Array[SlotData]
@export var buy_offers: Array[BuyOffer]
@export var available_money: int
@export var base_desire: int
var buy_inventory_spot = -1

func market_update():
	make_buy_offers()
	consume_products()

func make_buy_offers():
	for index in buy_offers:
		buy_inventory_spot += 1
		index.item_data = inventory[buy_inventory_spot].item_data
		index.quantity = randi_range(available_money*0.75, available_money*2)
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		index.owner = self
		retail_buy_offer.emit(index)
	buy_inventory_spot = -1
	
func consume_products():
	for index in inventory:
		index.quantity = 0
