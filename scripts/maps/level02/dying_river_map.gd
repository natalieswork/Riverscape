extends Node2D


@onready var BG_music_dying_river = $"AudioStream_dying_river"
var BG_music_on_dying =true


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_music_status()
	
func update_music_status():
	if BG_music_on_dying:
		if !BG_music_dying_river.playing:
			BG_music_dying_river.play()
	else:
		BG_music_dying_river.stop()
