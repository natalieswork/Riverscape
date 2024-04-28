extends Button

var bus_master := AudioServer.get_bus_index("Master")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	AudioServer.set_bus_mute(bus_master, not AudioServer.is_bus_mute(bus_master))
