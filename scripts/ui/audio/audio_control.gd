extends Control

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass # Replace with function body.
