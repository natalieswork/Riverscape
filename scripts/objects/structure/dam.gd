extends Node2D

@export var inventory: Inv

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interact_body_entered(body):
	if body.has_method("player"):
		global.player_in_dam_area = true


func _on_interact_body_exited(body):
	if body.has_method("player"):
		global.player_in_dam_area = false
