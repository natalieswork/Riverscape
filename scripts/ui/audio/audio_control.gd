extends Control

var is_open = false
@onready var quit_confirm = $quit_confirm
@onready var player_inv: Inv = preload("res://scenes/inventory/player_inventory.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	quit_confirm.visible = false
	close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		# Sound effect?
		if is_open:
			close()
		elif !global.dam_menu_open:
			open()
		else:
			print("can open audio settings, other ui is open")


func open():
	visible = true 
	is_open = true
	global.setting_menu_open = true


func close():
	visible = false
	is_open = false
	global.setting_menu_open = false


func _on_quit_pressed():
	quit_confirm.visible = true


func _on_yes_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	print("Quit to main menu")
	player_inv.reset()
	global.new_game_stats()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_no_pressed():
	quit_confirm.visible = false
