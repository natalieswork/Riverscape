extends Node2D

enum State {
	ALIVE, CUTTING, CUTDOWN
}
var state = State.ALIVE
var player_in_area = false 

var branch = preload("res://scenes/objects/branch_collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == State.CUTDOWN:
		$respawn.start()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animation()
	cutdown_tree()


func play_animation():
	var anim = $AnimatedSprite2D
	
	var anim_name = ""
	match state:
		State.ALIVE:
			anim_name = "default"
		State.CUTDOWN:
			anim_name = "cutdown"
		State.CUTTING:
			anim_name = "cutting"
	
	$AnimatedSprite2D.play(anim_name)


func cutdown_tree():
	if player_in_area and state == State.ALIVE:
		if Input.is_action_just_pressed("cutdown_tree"):
			state = State.CUTTING
			drop_branch()


func _on_cutdown_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_cutdown_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_respawn_timeout():
	if state == State.CUTDOWN:
		state = State.ALIVE


func _on_animated_sprite_2d_animation_finished():
	if state == State.CUTTING:
		state = State.CUTDOWN 

func drop_branch():
	var branch_instance = branch.instantiate()
	branch_instance.global_position = $Marker2D.global_position
	get_parent().add_child(branch_instance)
	
	await get_tree().create_timer(3).timeout
	$respawn.start()
	
