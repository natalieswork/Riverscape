extends Control

class_name DamUpgradeUI

signal add_branch

var is_open = false
@onready var dam_inv: Inv = preload("res://scenes/objects/structure/dam_inventory.tres")
@onready var player_inv: Inv = preload("res://scenes/inventory/player_inventory.tres")
@onready var progress_bar: ProgressBar = $NinePatchRect/VBoxContainer/ProgressBar
@onready var level_text: Label  = $NinePatchRect/VBoxContainer/HBoxContainer/level
@onready var count_text: Label = $NinePatchRect/VBoxContainer/HBoxContainer/count

# Called when the node enters the scene tree for the first time.
func _ready():
	close()
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !global.player_in_dam_area:
		close()
		
	if global.player_in_dam_area and Input.is_action_just_pressed("inspect_structure"):
		if is_open:
			close()
		else:
			open()


func open():
	visible = true 
	is_open = true


func close():
	visible = false
	is_open = false

func update():
	print("called")
	var branch_slot = null
	for slot in dam_inv.slots:
		if slot != null and slot.item != null and slot.item.name == "branch":
			branch_slot = slot
			break
			

	if branch_slot != null:
		count_text.text = "(" + str(branch_slot.amount) + "/" + str(global.dam_max_branch) + ")"
		progress_bar.value = branch_slot.amount
		progress_bar.max_value = global.dam_max_branch
	else:
		count_text.text = "(0/" + str(global.dam_max_branch) + ")"
		

func _on_add_one_pressed():
	emit_signal("add_branch", 1)
	update()


func _on_add_all_pressed():
	var amount = player_inv.get_item_amount("branch")
	print(amount)
	emit_signal("add_branch", amount)
	update()
