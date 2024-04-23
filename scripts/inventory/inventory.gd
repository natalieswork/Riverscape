extends Resource

class_name Inv

signal update 

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty(): # add to exisitng slot 
		itemslots[0].amount += 1 
	else: # add item to empty slot 
		var emptyslots =  slots.filter(func(slot): return slot.item == null)
		emptyslots[0].item = item 
		emptyslots[0].amount = 1
		
	update.emit()
