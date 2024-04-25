extends HSlider

@export var audio_bus_music := "Music"

@onready var _bus_music := AudioServer.get_bus_index(audio_bus_music)


func _ready() -> void:

	value = db_to_linear(AudioServer.get_bus_volume_db(_bus_music))

	
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_music, linear_to_db(value))


