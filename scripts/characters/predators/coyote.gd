extends CharacterBody2D

const SPEED = 50
var chase_player = false 
var player = null 
var health = 100
var player_in_attack_zone = false
var can_take_damage = true  

@export var knockback_power: int = 3500

var delay_timer = 6
signal encounter_music_started
signal encounter_music_stopped

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
	
	print("encounter")
	emit_signal("encounter_music_started")


func _on_detection_area_body_exited(body):
	player = null
	chase_player = false
	print("stopped")
	emit_signal("encounter_music_stopped")



func enemy():
	pass


func _on_coyote_hitbox_body_entered(body):
	if body.has_method("player"):
		var damage = 5
		global.player_health = global.player_health - damage
		player_in_attack_zone = true
		


func _on_coyote_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		

func handle_damage():
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


func _on_coyote_hurtbox_area_entered(area):
	if area.is_in_group('attack_box'):
		if can_take_damage == true:
			health = health - 20
			$damage_cooldown.start()
			can_take_damage == false
			print("coyote health ", health)
			
			var knockback_direction = (position - area.position).normalized() * knockback_power
			velocity = knockback_direction
			move_and_slide()

func _on_new_forest_map_encounter_music_started():
	pass # Replace with function body.
