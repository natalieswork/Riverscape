extends Node2D

@onready var BG_music_forest_dead = $"AudioStream_dead_forest"
@onready var coyote = $"Coyote"
@onready var encounter = $"AudioStream_encounter"
var BG_music_on = true
var encounter_music_on = false
signal encounter_music_started
signal encounter_music_stopped

# Called when the node enters the scene tree for the first time.
func _ready():
	$coyote.connect("encounter_music_started", _on_encounter_music_started)
	$coyote.connect("encounter_music_stopped", _on_encounter_music_stopped)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func _on_encounter_music_started():
	print("music")
	BG_music_on = false
	encounter_music_on= true

func _on_encounter_music_stopped():
	print("stoppy")
	BG_music_on = true
	encounter_music_on = false


func _on_coyote_2_encounter_music_stopped():
	_on_encounter_music_stopped()


func _on_coyote_encounter_music_stopped():
	_on_encounter_music_stopped()


func _on_coyote_encounter_music_started():
	_on_encounter_music_started()


func _on_coyote_2_encounter_music_started():
	_on_encounter_music_started()
