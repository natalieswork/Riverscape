extends Node2D

signal encounter_music_started
signal encounter_music_stopped

@onready var BG_music_forest = $Audio/AudioStream_alive_forest
@onready var encounter = $Audio/AudioStream_encounter_alive

var BG_music_on = true
var encounter_music_on = false

func _ready():
	pass
	#$coyote.connect("encounter_music_started", _on_encounter_music_started)
	#$coyote.connect("encounter_music_stopped", _on_encounter_music_stopped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	update_music_status()


func update_music_status():
	if BG_music_on:
		
		encounter.stop()
		if !BG_music_forest.playing:
			BG_music_forest.play()
	else:
		BG_music_forest.stop()
		
	if encounter_music_on:
		BG_music_forest.stop()
		if !encounter.playing:
			encounter.play()
	else:
		encounter.stop()


func _on_forest_exit_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
	
func change_scene():
	if global.transition_scene == true:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		if global.current_scene == "forest_map":
			get_tree().change_scene_to_file("res://scenes/maps/level03/alive_river_map.tscn")
			global.finish_changescenes()
