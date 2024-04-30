extends HSlider

@export var audio_bus_master := "Master"

@onready var _bus_master := AudioServer.get_bus_index(audio_bus_master)



func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus_master))



func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_master, linear_to_db(value))



func _on_mouse_exited():
	pass # Replace with function body.
