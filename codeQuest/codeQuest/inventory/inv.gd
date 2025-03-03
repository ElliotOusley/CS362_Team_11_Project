# Contains data and functions related to holding inventory data. 
extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot] # See inv_slot.gd for InvSlot data.

# Adds an item to the inventory. If there is already a slot with this
# type of item in the inventory, increment inventory slot by 1
func insert(item:InvItem): # See inv_item.gd for inv_item data.
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots =  slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	update.emit()
		
