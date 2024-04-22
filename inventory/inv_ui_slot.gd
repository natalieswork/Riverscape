extends Panel

@onready var item_icon: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if !slot.item: # nothing in the slot
		item_icon.visible = false 
		amount_text.visible = false 
	else:
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		amount_text.visible = true 
		amount_text.text = str(slot.amount)
