extends StaticBody2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

@onready var sprite2d = $Sprite2D
@onready var HarvestableArea2D = $HarvestableArea2D

func _on_area_2d_area_entered(area):
	if HarvestableArea2D.harvestable != 0:
		harvest_bush()
	else:
		pass

func harvest_bush():
	sprite2d.scale = Vector2(0.5, 0.5)
