extends Control

class_name DamUpgradeUI

signal add_branch

var is_open = false
@onready var dam_inv: Inv = preload("res://scenes/objects/structure/dam_inventory.tres")
@onready var player_inv: Inv = preload("res://scenes/inventory/player_inventory.tres")
@onready var progress_bar: ProgressBar = $NinePatchRect/VBoxContainer/HBoxContainer/ProgressBar
@onready var level_text: Label  = $NinePatchRect/VBoxContainer/HBoxContainer2/level
@onready var count_text: Label = $NinePatchRect/VBoxContainer/HBoxContainer2/count

# Called when the node enters the scene tree for the first time.
func _ready():
	level_text.text = "Dam Level " + str(global.dam_level)
	close()
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.dam_upgraded:
		close()
		update()
		
		
	if !global.player_in_dam_area:
		# Sound effect?
		close()
		
	if global.player_in_dam_area and Input.is_action_just_pressed("inspect_structure"):
		# Sound effect?
		if is_open:
			close()
		elif !global.setting_menu_open:
			open()
		else:
			print("cant open dam ui, another ui is open")


func open():
	visible = true 
	is_open = true
	global.dam_menu_open = true


func close():
	visible = false
	is_open = false
	global.dam_menu_open = false
	

func update():
	#updates the ui
	var branch_slot = null
	for slot in dam_inv.slots:
		if slot != null and slot.item != null and slot.item.name == "branch":
			branch_slot = slot
			break
			

	if branch_slot != null:
		level_text.text = "Dam Level " + str(global.dam_level)
		count_text.text = "(" + str(branch_slot.amount) + "/" + str(global.dam_max_branch) + ")"
		progress_bar.value = branch_slot.amount
		progress_bar.max_value = global.dam_max_branch
	else:
		count_text.text = "(0/" + str(global.dam_max_branch) + ")"
		

func _on_add_one_pressed():
	var branches_available = player_inv.get_item_amount("branch")
	#if branches_available > 0:
		# Sound effect? No branch available noise
	#else:
		# No branches sound effect?
	
	# calc how many more branches can be added to the dam
	var current_branch_amount = dam_inv.get_item_amount("branch")
	var space_left = global.dam_max_branch - current_branch_amount

	# Only proceed if there is space left
	if space_left > 0:
		emit_signal("add_branch", 1)
		update()
	else:
		# trigger upgrade?
		print("Dam Full.")


func _on_add_all_pressed():
	var current_branch_amount = dam_inv.get_item_amount("branch")
	var space_left = global.dam_max_branch - current_branch_amount

	# Calculate how many branches the player has
	var branches_to_add = player_inv.get_item_amount("branch")
	#if branches_to_add > 0:
		# Sound effect? No branch available noise
	#else:
		# No branches sound effect?

	# Cap the addition to the dam inv at the maximum space left
	branches_to_add = min(branches_to_add, space_left)

	if branches_to_add > 0:
		emit_signal("add_branch", branches_to_add)
		update()
	else:
		# trigger upgrade? 
		print("Dam Full.")
		
