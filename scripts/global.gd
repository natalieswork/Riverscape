extends Node

var game_first_loaded = true
var player_active_attack = false
var player_health = 100

var current_scene = "river_map" # river_map, forest_map
var transition_scene = false

var player_start_posx = 576
var player_start_posy = 153

var player_exit_forest_posx = 1136
var player_exit_forest_posy = 184

# upgrade sytem vars
var player_in_dam_area= false

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "river_map":
			current_scene = "forest_map"
		else:
			current_scene = "river_map"
	

