extends Panel

@onready var item_icon: Sprite2D = $CenterContainer/Panel/item_display

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(item: InvItem):
	if !item:
		item_icon.visible = false 
	else:
		item_icon.visible = true
		item_icon.texture = item.texture
