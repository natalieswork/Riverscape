extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	fall_from_tree()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fall_from_tree():
	$AnimatedSprite2D.visible = true
	$AnimationPlayer.play("fall_from_tree")
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("fade")
	print("+1 branch")
	await get_tree().create_timer(0.3).timeout
	queue_free()
	
