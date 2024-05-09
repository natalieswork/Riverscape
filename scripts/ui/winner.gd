extends CanvasLayer
@onready var player_inv: Inv = preload("res://scenes/inventory/player_inventory.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.new_game_stats()
	player_inv.reset()
	$AnimationPlayer.play("float_end")
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("exit_text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		print("Reset back to main menu")
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
