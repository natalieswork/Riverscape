extends Node

signal dam_upgrade

var game_first_loaded = true
var player_active_attack = false
var player_health = 100

var current_scene = "river_map" # river_map, forest_map
var transition_scene = false

var player_start_posx = 560
var player_start_posy = 290

var player_exit_forest_posx = 975
var player_exit_forest_posy = 265

# upgrade sytem vars
# dam vars
var player_in_dam_area = false
var dam_level = 1
var dam_upgraded = false
var dam_max_branch = 5

# lodge vars
var player_in_lodge_area = false
var lodge_level = 1
var lodge_upgraded = false
var lodge_max_branch = 5

# map level
var world_level = 1

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "river_map":
			current_scene = "forest_map"
		else:
			current_scene = "river_map"


func upgrade_dam():
	dam_level += 1
	if dam_level == world_level:
		if dam_level == 2:
			dam_max_branch = 10 # new goal after upgrade
		elif dam_level == 3:
			dam_max_branch = 15  
		
	dam_upgrade.emit(dam_level)

