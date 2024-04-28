extends HSlider


@export var audio_bus_SFX := "SFX"


@onready var _bus_sfx := AudioServer.get_bus_index(audio_bus_SFX)



func _ready() -> void:

	value = db_to_linear(AudioServer.get_bus_volume_db(_bus_sfx))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_sfx, linear_to_db(value))
	


func _on_mouse_exited():
	pass # Replace with function body.
