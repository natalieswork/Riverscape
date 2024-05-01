extends Resource

class_name Inv

signal update 

@export var slots: Array[InvSlot]

func insert(item: InvItem, amount: int = 1) -> bool:
	# Check if the item already exists in the inventory
	for slot in slots:
		if slot != null and slot.item == item:
			slot.amount += amount
			update.emit()
			return true

	# If item does not exist, find an empty slot
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount = amount
			update.emit()
			return true
			
	# No empty slot found
	print("No empty slot available!")
	return false


func remove(item: InvItem, amount: int = 1) -> bool:
	for slot in slots:
		if slot.item == item:
			if slot.amount >= amount:
				slot.amount -= amount
				update.emit()
				if slot.amount == 0:
					slot.item = null
				return true
			else:
				print("Not enough item quantity to remove!")
			return false
	
	print("Item not found in inventory!")
	return false


func get_item_amount(name: String) -> int:
	for slot in slots:
		if slot != null and slot.item != null and slot.item.name == name:
			return slot.amount
	return 0


func find_item(item_name: String) -> InvItem:
	for slot in slots:
		if slot.item != null and slot.item.name == item_name:
			return slot.item
	return null
