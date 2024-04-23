extends NinePatchRect

@onready var inv: Inv = preload("res://scenes/inventory/player_inventory.tres")
@onready var branch_count_label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	inv.update.connect(update_branch_display)
	update_branch_display()

func update_branch_display():
	var branch_slot = null
	for slot in inv.slots:
		if slot.item != null and slot.item.name == "branch":
			branch_slot = slot
			break

	if branch_slot != null:
		branch_count_label.text = str(branch_slot.amount)
	else:
		branch_count_label.text = "0"  
