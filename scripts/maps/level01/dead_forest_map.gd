extends Node2D

@onready var BG_music_forest_dead = $Audio/AudioStream_dead_forest
@onready var encounter = $Audio/AudioStream_encounter

var BG_music_on = true
var encounter_music_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	update_music_status()

	
func update_music_status():
	if BG_music_on:
		
		encounter.stop()
		if !BG_music_forest_dead.playing:
			BG_music_forest_dead.play()
	else:
		BG_music_forest_dead.stop()
		
	if encounter_music_on:
		BG_music_forest_dead.stop()
		if !encounter.playing:
			encounter.play()
	else:
		encounter.stop()


func _on_forest_exit_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "forest_map":
			get_tree().change_scene_to_file("res://scenes/maps/level01/dead_river_map.tscn")
			global.finish_changescenes()
