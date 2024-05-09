extends CanvasLayer
@onready var player_inv: Inv = preload("res://scenes/inventory/player_inventory.tres")
@onready var branch_count = $ColorRect/branch_count
var brnaches = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	var branch_slot = null
	for slot in player_inv.slots:
		if slot != null and slot.item != null and slot.item.name == "branch":
			branch_slot = slot
			break
	
	if branch_slot == null:
		branch_count.visible = false
	else:
		var branches = branch_slot.amount
		if branches == 0:
			branch_count.visible = false
		elif branches == 1:
			branch_count.text = "You lost 1 branch!"
		else: 
			branch_count.text = "You lost " + str(branches) + " branches!"
			
	global.player_health = global.player_max_health
	player_inv.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		global.respawn_player_at_river()
