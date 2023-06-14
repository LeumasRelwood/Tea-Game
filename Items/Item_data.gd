extends Resource
class_name ItemData

@export var name : String
@export_multiline var description : String
@export var stackable : bool = false
@export var texture : AtlasTexture
@export var recipe : Array[SlotData]

#enum ItemType { GENERIC, CONSUMABLE, QUEST, EQUIPMENT}
#@export var type : ItemType

func use(target) -> void:
	pass
