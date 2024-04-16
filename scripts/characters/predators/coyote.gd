extends CharacterBody2D

const SPEED = 50
var chase_player = false 
var player = null 
var health = 100
var player_in_attack_zone = false
var can_take_damage = true  


func _physics_process(delta):
	handle_damage()
	update_health()
	
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


func enemy():
	pass


func _on_coyote_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_coyote_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		


func handle_damage():
	if player_in_attack_zone and global.player_active_attack == true:
		if can_take_damage == true:
			health = health - 20
			$damage_cooldown.start()
			can_take_damage = false
			print("coyote health ", health)
			
			if health <= 0:
				self.queue_free()


func _on_damage_cooldown_timeout():
	can_take_damage = true 

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true 
