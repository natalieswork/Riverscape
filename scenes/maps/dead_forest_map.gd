extends Node2D


@onready var BG_music_forest_dead = $"AudioStream_dead_forest"
var BG_music_on =true


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_music_status()
	
func update_music_status():
	if BG_music_on:
		if !BG_music_forest_dead.playing:
			BG_music_forest_dead.play()
	else:
		BG_music_forest_dead.stop()
