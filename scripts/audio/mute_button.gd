extends Button
var muted_color = Color(0.5, 0.5, 0.5)
var unmuted_color = Color(1, 1, 1)
var bus_master := AudioServer.get_bus_index("Master")
# Called when the node enters the scene tree for the first time.
func _ready():
	update_button_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	AudioServer.set_bus_mute(bus_master, not AudioServer.is_bus_mute(bus_master))
	update_button_color()
	
func update_button_color():
	# Set button color based on mute state
	if AudioServer.is_bus_mute(bus_master):
		self.modulate = muted_color
	else:
		self.modulate = unmuted_color
