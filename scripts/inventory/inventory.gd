extends Resource

class_name Inv

signal update 

@export var slots: Array[InvSlot]

func insert(item: InvItem, amount: int = 1):
	# Check if the item already exists in the inventory
	for slot in slots:
		if slot.item == item:
			slot.amount += amount
			update.emit()
			return

	# If item does not exist, find an empty slot
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount = amount
			update.emit()
			return
			
	# No empty slot found
	print("No empty slot available!")


func remove(item: InvItem, amount: int = 1):
	for slot in slots:
		if slot.item == item:
			if slot.amount >= amount:
				slot.amount -= amount
				update.emit()
				if slot.amount == 0:
					slot.item = null
			else:
				print("Not enough item quantity to remove!")
			return

	print("Item not found in inventory!")


func get_item_amount(item: InvItem) -> int:
	for slot in slots:
		if slot.item == item:
			return slot.amount
	return 0
