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

var tree_paths = {
	"oak": {
		1: "res://scenes/objects/tree_config/oak_tree01.tres",
		2: "res://scenes/objects/tree_config/oak_tree02.tres",
		3: "res://scenes/objects/tree_config/oak_tree03.tres"
	},
	"pine": {
		1: "res://scenes/objects/tree_config/pine_tree01.tres",
		2: "res://scenes/objects/tree_config/pine_tree02.tres",
		3: "res://scenes/objects/tree_config/pine_tree03.tres"
	}
}

@export var item: InvItem
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomly pick a type when the node is initialized
	var ran_int = randi() % Type.size()
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
	var tree_path = ""
	match tree_type:
		Type.OAK:
			tree_path = tree_paths["oak"].get(global.world_level, tree_paths["oak"][1])  # Fallback to level 1 if no specific level match
		Type.PINE:
			tree_path = tree_paths["pine"].get(global.world_level, tree_paths["pine"][1])  # Fallback to level 1 if no specific level match

	var tree_frames = load(tree_path)
	$AnimatedSprite2D.frames = tree_frames

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


@onready var chop_tree_sound = $"AudioStream_tree_cut"
func cutdown_tree():
	if player_in_area and state == State.ALIVE:
		if Input.is_action_just_pressed("cutdown_tree"):
			if !chop_tree_sound.playing:
				chop_tree_sound.play()
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
	
