extends Control

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	close()

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
