extends ItemDataConsumable
class_name ItemDataConsumableHealth

@export var heal_value: int

func use(target) -> void:
	if heal_value != 0:
		target.heal(heal_value)

func is_usable() -> bool:
	if PlayerStats.health < PlayerStats.max_health:
		return true
	else:
		return false
