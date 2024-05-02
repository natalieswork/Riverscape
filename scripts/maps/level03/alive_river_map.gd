extends Node2D


@onready var BG_music_river = $Audio/AudioStream_BG_Music_river
var BG_music_on = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_first_loaded == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
		
	else:
		$player.position.x = global.player_exit_forest_posx
		$player.position.y = global.player_exit_forest_posy



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	update_music_status()
	
func update_music_status():
	if BG_music_on:
		if !BG_music_river.playing:
			BG_music_river.play()
	else:
		BG_music_river.stop()


func _on_forest_entrance_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func change_scene():
	if global.transition_scene == true:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		if global.current_scene == "river_map":
			get_tree().change_scene_to_file("res://scenes/maps/level03/alive_forest_map.tscn")
			global.game_first_loaded = false
			global.finish_changescenes()
