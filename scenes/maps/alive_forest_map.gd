extends Node2D
@onready var BG_music_forest = $"AudioStream_alive_forest"
var BG_music_on =true

@onready var coyote = $"Coyote"
@onready var encounter_alive = $"AudioStream_encounter_alive"
var encounter_music_on = false
signal encounter_music_started
signal encounter_music_stopped

func _ready():
	$coyote.connect("encounter_music_started", _on_encounter_music_started)
	$coyote.connect("encounter_music_stopped", _on_encounter_music_stopped)

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_music_status()
	
func update_music_status():
	if BG_music_on:
		encounter_alive.stop()
		if !BG_music_forest.playing:
			BG_music_forest.play()
	else:
		BG_music_forest.stop()
		
	if encounter_music_on:
		BG_music_forest.stop()
		if !encounter_alive.playing:
			encounter_alive.play()
	else:
		encounter_alive.stop()
func _on_encounter_music_started():
	print("music")
	BG_music_on = false
	encounter_music_on= true

func _on_encounter_music_stopped():
	print("stoppy")
	BG_music_on = true
	encounter_music_on = false


func _on_coyote_encounter_music_started():
	_on_encounter_music_started()


func _on_coyote_encounter_music_stopped():
	_on_encounter_music_stopped()
