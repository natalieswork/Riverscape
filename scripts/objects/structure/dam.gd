extends Node2D

@export var dam_inventory: Inv
var player = null
var branch = preload("res://scenes/objects/branch_collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interact_body_entered(body):
	if body.has_method("player"):
		global.player_in_dam_area = true
		player = body


func _on_interact_body_exited(body):
	if body.has_method("player"):
		global.player_in_dam_area = false

func add_branch(amount: int = 1):
	if player:
		var branch_item = player.inventory.find_item("branch") # Returns an InvItem directly
		if branch_item:
			if player.inventory.remove(branch_item, amount): # Check if successfully removed
				if dam_inventory.insert(branch_item, amount): # Check if successfully inserted
					var damb = dam_inventory.get_item_amount("branch")
					print("Dam number: ", damb)
					print("Amount passed to dam add: ", amount)
				else:
					print("Failed to insert branches into dam inventory")
			else:
				print("Failed to remove branches from player inventory")
		else:
			print("No branches to add")
	else:
		print("Player has no branches")



func _on_upgrade_ui_add_branch(amount: int):
	print("amount passed to dam", amount)
	add_branch(amount)
