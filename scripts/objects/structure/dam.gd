extends Node2D

@export var dam_inventory: Inv
var player = null
var branch = preload("res://scenes/objects/branch_collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.dam_upgrade.connect(_on_dam_upgrade)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interact_body_entered(body):
	if body.has_method("player"):
		global.player_in_dam_area = true
		player = body # needed to access player inventory


func _on_interact_body_exited(body):
	if body.has_method("player"):
		global.player_in_dam_area = false


func add_branch(amount: int = 1):
	if player:
		var branch_item = player.inventory.find_item("branch") 
		if branch_item:
			if player.inventory.remove(branch_item, amount): # check successfully removed
				if dam_inventory.insert(branch_item, amount): # check successfully inserted
					check_dam_upgrade()
				else:
					print("Failed to insert branches into dam inventory")
			else:
				print("Failed to remove branches from player inventory")
		else:
			print("No branches to add")
	else:
		print("Player has no branches")


func check_dam_upgrade():
	if dam_inventory.get_item_amount("branch") >= global.dam_max_branch:
		# Sound effect? Yayyy you got the upgrade
		global.upgrade_dam()


func _on_upgrade_ui_add_branch(amount: int):
	print("amount passed to dam", amount)
	add_branch(amount)


func _on_dam_upgrade(new_level):
	print("Dam upgraded to level ", new_level, "!!!!!!!!!!")
	# Any additional logic needed when the dam upgrades
