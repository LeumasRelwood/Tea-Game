extends Node

signal wholesale_buy_offer(buy_offer: BuyOffer)
signal retail_sale_offer(sell_offer: SellOffer)
var buy_inventory_spot = -1
var sell_inventory_spot = -1

@export var inventory: Array[SlotData]
@export var buy_offers: Array[BuyOffer]
@export var sell_offers: Array[SellOffer]
@export var storage_capacity: int
@export var current_storage: int
@export var available_money: int

func market_update():
	make_buy_offers()
	make_sell_offers()

func make_buy_offers():
	for index in buy_offers:
		buy_inventory_spot += 1
		index.item_data = inventory[buy_inventory_spot].item_data
		index.quantity = randi_range(available_money*0.75, available_money*2)
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		index.owner = self
		wholesale_buy_offer.emit(index)
	buy_inventory_spot = -1

func make_sell_offers():
	for index in sell_offers:
		sell_inventory_spot += 1
		index.item_data = inventory[sell_inventory_spot].item_data
		index.quantity = inventory[sell_inventory_spot].quantity
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		index.owner = self
		retail_sale_offer.emit(index)
	sell_inventory_spot = -1
