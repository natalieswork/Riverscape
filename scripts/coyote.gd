extends CharacterBody2D

const SPEED = 50
var chase_player = false 
var player = null 

func _physics_process(delta):
	if chase_player:
		position += (player.position - position).normalized() * SPEED * delta
		move_and_collide(Vector2(0,0)) 

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.play("walk_left")
		else:
			$AnimatedSprite2D.play("walk_right")
	else: 
		$AnimatedSprite2D.play("idle_right")

func _on_detection_area_body_entered(body):
	player = body
	chase_player = true 


func _on_detection_area_body_exited(body):
	player = null
	chase_player = false
