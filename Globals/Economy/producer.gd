extends Node

signal wholesale_sale_offer(sell_offer: SellOffer)

@export var inventory: Array[SlotData]
@export var sell_offers: Array[SellOffer]
@export var storage_capacity: int
@export var current_storage: int
@export var production_capacity: int
var inventory_spot = -1

func market_update():
	produce_tea()
	make_sell_offers()

func produce_tea():
	for slot_data in inventory:
		if slot_data:
			slot_data.quantity += randi_range(production_capacity/2, production_capacity*2)

func make_sell_offers():
	for index in sell_offers:
		inventory_spot += 1
		index.item_data = inventory[inventory_spot].item_data
		index.quantity = inventory[inventory_spot].quantity
		index.asking_price = randi_range(index.item_data.base_value*.75, index.item_data.base_value*1.25)
		index.owner = self
		wholesale_sale_offer.emit(index)
	inventory_spot = -1
