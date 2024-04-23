extends Node2D

enum State {
	ALIVE, CUTTING, CUTDOWN
}

# handle different tree types
enum Type {
	OAK, # 0
	PINE # 1
}

var tree_type

var state = State.ALIVE
var player_in_area = false 

var branch = preload("res://scenes/objects/branch_collectable.tscn")

@export var item: InvItem
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomly pick a type when the node is initialized
	var ran_int = randi() % Type.size()
	print("ran_int ", ran_int)
	if  ran_int == 0:
		tree_type = Type.OAK
	else:
		tree_type = Type.PINE
		
	# Initialize the tree based on the type.
	initialize_tree()
	$AnimatedSprite2D.play("default")
	
	if state == State.CUTDOWN:
		$respawn.start()


func initialize_tree():
	match tree_type:
		Type.OAK:
		# Set properties specific to OAK.
			var oak_frames = preload("res://scenes/objects/oak_tree.tres")
			$AnimatedSprite2D.frames = oak_frames
			print("Initialized as an Oak tree.")
		Type.PINE:
		# Set properties specific to PINE.
			var pine_frames = preload("res://scenes/objects/pine_tree.tres")
			$AnimatedSprite2D.frames = pine_frames
			print("Initialized as an Pine tree.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animation()
	cutdown_tree()


func play_animation():
	
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
		player = body


func _on_cutdown_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_respawn_timeout():
	if state == State.CUTDOWN:
		state = State.ALIVE

# only plays cutting animation once
func _on_animated_sprite_2d_animation_finished():
	if state == State.CUTTING:
		state = State.CUTDOWN 

func drop_branch():
	var branch_instance = branch.instantiate()
	branch_instance.global_position = $Marker2D.global_position
	get_parent().add_child(branch_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$respawn.start()
	
