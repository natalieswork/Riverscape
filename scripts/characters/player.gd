extends CharacterBody2D

enum Direction {
	RIGHT, LEFT, DOWN, UP
}

enum State {
	IDLE, WALK, RUN, ATTACK, DEAD
}

var current_direction = Direction.DOWN
var current_state = State.IDLE
const speed = 100
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var alive = true


func _ready():
	update_animation()


func _physics_process(delta):
	player_movement(delta)
	attack()
	enemy_attack()
	current_camera()
	
	if health <= 0:
		die()


func player():
	pass


func player_movement(delta):

	if Input.is_action_pressed("ui_right"):
		current_direction = Direction.RIGHT
		current_state = State.WALK
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = Direction.LEFT
		current_state = State.WALK
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = Direction.DOWN
		current_state = State.WALK
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = Direction.UP
		current_state = State.WALK
		velocity.y = -speed
		velocity.x = 0
	elif current_state != State.ATTACK:
		current_state = State.IDLE
		velocity.y = 0
		velocity.x = 0
		
	update_animation()
	move_and_slide()



func update_animation():
	var anim_name = ""
	match current_state:
		State.IDLE:
			anim_name = "idle_"
		State.WALK:
			anim_name = "walk_"
		State.RUN:
			anim_name = "run_"
		State.ATTACK:
			anim_name = "attack_"
		State.DEAD:
			anim_name = "death"
			

	if current_state != State.DEAD:
		match current_direction:
			Direction.RIGHT:
				anim_name += "right"
			Direction.LEFT:
				anim_name += "left"
			Direction.DOWN:
				anim_name += "front"
			Direction.UP:
				anim_name += "back"
	
	$AnimatedSprite2D.play(anim_name)


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
	if Input.is_action_just_pressed("attack"):
		current_state = State.ATTACK
		global.player_active_attack = true
		update_animation()
		$deal_attack_timer.start()



func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_active_attack = false
	current_state = State.IDLE 
	update_animation()


func current_camera():
	if global.current_scene == "river_map":
		$river_camera.enabled = true
		$forest_camera.enabled = false
	elif global.current_scene == "forest_map":
		$river_camera.enabled = false
		$forest_camera.enabled = true

func die():
	health = 0
	alive = false
	current_state = State.DEAD
	update_animation()
	print("Player has been killed.")
	self.queue_free() 
