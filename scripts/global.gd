extends Node

signal dam_upgrade

var game_first_loaded = true
var player_active_attack = false
var player_health = 100
var player_max_health = 100

var current_scene = "river_map" # river_map, forest_map
var transition_scene = false

var player_start_posx = 650
var player_start_posy = 325

var player_exit_forest_posx = 975
var player_exit_forest_posy = 265

# upgrade sytem vars
# dam vars
var player_in_dam_area = false
var dam_level = 1
var dam_upgraded = false
var dam_max_branch = 1
var dam_max_branch_2 = 2
var dam_max_branch_3 = 3

# lodge vars
var player_in_lodge_area = false
var lodge_level = 1
var lodge_upgraded = false
var lodge_max_branch = 5

# ui aides
var dam_menu_open = false
var setting_menu_open = false

var world_level = 1
var has_played_death_sound = false

var map_paths = {
	"river": {
		1: "res://scenes/maps/level01/dead_river_map.tscn",
		2: "res://scenes/maps/level02/dying_river_map.tscn",
		3: "res://scenes/maps/level03/alive_river_map.tscn"
	},
	"forest": {
		1: "res://scenes/maps/level01/dead_forest_map.tscn",
		2: "res://scenes/maps/level02/dying_forest_map.tscn",
		3: "res://scenes/maps/level03/alive_forest_map.tscn"
	}
}


func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "river_map":
			current_scene = "forest_map"
		else:
			current_scene = "river_map"


func check_and_upgrade_world_level():
	if dam_upgraded and world_level < 3: # (and lodge_upgraded) - natalie uncomment this when lodge is implemented
		world_level += 1
		
		load_new_map()
		print("World level increased to ", world_level)
		dam_upgraded = false  # reset after world level increment


func upgrade_dam():
	dam_upgraded = true
	dam_level += 1
	await get_tree().create_timer(2).timeout # play damn upgrade animation
	if dam_level <= 3:
		check_and_upgrade_world_level()
		update_dam_stats()
		dam_upgrade.emit(dam_level)
	elif dam_level == 4:
		load_win_scene()
	else:
		print("Dam is already at maximum level.")


func update_dam_stats():
	if dam_level == world_level:
		if dam_level == 2:
			dam_max_branch = dam_max_branch_2  # New goal after upgrade
		elif dam_level == 3:
			dam_max_branch = dam_max_branch_3  # New goal after final upgrade
		print("Dam stats updated: Level", dam_level, "with max branches", dam_max_branch)


func load_new_map():
	var new_map_path = get_map_path("river")
	if new_map_path != "":
		game_first_loaded = true
		start_pos_update()
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file(new_map_path)
	else:
		print("Failed to load new map for: ", current_scene)



func get_map_path(name: String) -> String:
	if name in map_paths and world_level in map_paths[name]:
		return map_paths[name][world_level]
	else:
		print("Invalid map name or level")
		return ""
		

func load_win_scene():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	print("Won the game!")
	var win_scene_path = "res://scenes/ui/winner.tscn"
	get_tree().change_scene_to_file(win_scene_path)
	
	
func start_pos_update():
	if world_level == 2:
		global.player_start_posx =  584
		global.player_start_posy = 272
	elif world_level == 3:
		global.player_start_posx =  646
		global.player_start_posy = 227


func load_death_scene():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	var died_scene_path = "res://scenes/ui/died.tscn"
	get_tree().change_scene_to_file(died_scene_path)


func respawn_player_at_river():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	global.current_scene = "river_map"
	get_tree().change_scene_to_file(global.get_map_path("river"))

