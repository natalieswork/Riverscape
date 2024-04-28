extends Node2D

@onready var BG_music_forest_dying = $"AudioStream_dead_forest"
var BG_music_on =true
@onready var coyote = $"Coyote"
@onready var encounter = $"AudioStream_encounter"
var encounter_music_on = false
signal encounter_music_started
signal encounter_music_stopped

func _ready():
	$coyote.connect("encounter_music_started", _on_encounter_music_started)
	$coyote.connect("encounter_music_stopped", _on_encounter_music_stopped)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_music_status()
	
func update_music_status():
	if BG_music_on:
		encounter.stop()
		if !BG_music_forest_dying.playing:
			BG_music_forest_dying.play()
	else:
		BG_music_forest_dying.stop()
		
	if encounter_music_on:
		BG_music_forest_dying.stop()
		if !encounter.playing:
			encounter.play()
	else:
		encounter.stop()

func _on_encounter_music_started():
	BG_music_on = false
	encounter_music_on= true

func _on_encounter_music_stopped():
	BG_music_on = true
	encounter_music_on = false

func _on_coyote_encounter_music_started():
	_on_encounter_music_started()


func _on_coyote_encounter_music_stopped():
	_on_encounter_music_stopped()
