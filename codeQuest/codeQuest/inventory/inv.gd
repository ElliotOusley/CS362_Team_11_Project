# Contains data and functions related to holding inventory data. 
extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot] # See inv_slot.gd for InvSlot data.

# Adds an item to the inventory. If there is already a slot with this
# type of item in the inventory, increment inventory slot by 1

func insert(item: InvItem, amount: int = -1):
	var item_slots = slots.filter(func(slot): 
		return slot.item && slot.item.name == item.name
	)

	if !item_slots.is_empty():
		if amount < 0:
			item_slots[0].amount += 1
		else:
			item_slots[0].amount = amount
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			if amount < 0:
				empty_slots[0].amount = 1
			else:
				empty_slots[0].amount = amount
	update.emit()
		
func get_slots():
	return slots
