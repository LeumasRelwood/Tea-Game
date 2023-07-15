extends Resource
class_name BuyOffer

var owner
@export var item_data: ItemData
@export var asking_price: float #will need to (stepify(asking_price, 0.01)
@export var quantity: int
