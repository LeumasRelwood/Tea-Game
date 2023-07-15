extends Resource
class_name CommodityMarket

@export var commodity_name: String
@export var item_data: ItemData
@export var buy_offers: Array[BuyOffer]
@export var sell_offers: Array[SellOffer]
@export var average_market_price: float
@export var quantity_of_transactions: int

