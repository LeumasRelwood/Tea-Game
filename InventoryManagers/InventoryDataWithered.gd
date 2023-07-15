extends InventoryData
class_name InventoryDataWithered

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataWithered:
		return grabbed_slot_data
	
	return super.drop_slot_data(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataWithered:
		return grabbed_slot_data
	
	return super.drop_single_slot_data(grabbed_slot_data, index)
