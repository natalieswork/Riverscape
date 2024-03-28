extends Node

var player_active_attack = false

var current_scene = "river_map" # river_map, forest_map
var transition_scene = false

var player_start_posx = 0
var player_start_posy = 0

var player_exit_forest_posx = 0
var player_exit_forest_posy = 0

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "river_map":
			current_scene = "forest_map"
		else:
			current_scene = "river_map"
	

