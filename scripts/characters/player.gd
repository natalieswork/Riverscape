extends CharacterBody2D

const speed = 100
var current_dir = "down"
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var alive = true
var active_attack = false


func _ready():
	$AnimatedSprite2D.play("idle_front")


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		alive = false # add end screen
		health = 0
		print("Player has been killed.")
		self.queue_free()

func player_movement(delta):

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.y = 0
		velocity.x = 0
		
	move_and_slide()


'''
1 is moving
0 is not moving/idle
'''
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	# RIGHT WALKING AND IDLE
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			if active_attack == false:
				anim.play("idle_right")
		
	# LEFT WALKING AND IDLE
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_left")
		elif movement == 0:
			if active_attack == false:
				anim.play("idle_left")
	# DOWN WALKING AND IDLE
	if dir == "down":
		if movement == 1:
			anim.play("walk_front")
		elif movement == 0:
			if active_attack == false:
				anim.play("idle_front")
	# UP WALKING AND IDLE
	if dir == "up":
		if movement == 1:
			anim.play("walk_back")
		elif movement == 0:
			if active_attack == false:
				anim.play("idle_back")
			


func player():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false


func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health = health - 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func attack():
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if Input.is_action_just_pressed("attack"):
		global.player_active_attack = true
		active_attack = true
		if dir == "right":
			anim.play("attack_right")
			$deal_attack_timer.start()
		if dir == "left":
			anim.play("attack_left")
			$deal_attack_timer.start()
		if dir == "down":
			anim.play("attack_front")
			$deal_attack_timer.start()	
		if dir == "up":
			anim.play("attack_back")
			$deal_attack_timer.start()
		
			


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_active_attack = false
	active_attack = false

