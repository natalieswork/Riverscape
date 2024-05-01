extends CharacterBody2D

@onready var playerWalkingAudio = $AudioStreamPlayer2D_walking
@onready var playerAttackAudio = $AudioStreamPlayer2D_attack
@onready var playerHurtAudio = $AudioStreamPlayer2D_hurt

@onready var player_low_health = $AudioStreamPlayer2D_low_health
@onready var player_death_sound = $AudioStreamPlayer2D_death
@onready var player_out_run = $AudioStreamPlayer2D_out_run

@export var inventory: Inv

enum Direction {
	RIGHT, LEFT, DOWN, UP
}

enum State {
	IDLE, WALK, RUN, ATTACK, DEAD
}

var current_direction = Direction.DOWN
var current_state = State.IDLE
const walk_speed = 100
const run_speed = 160
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
# var health = 100
var alive = true

# running vars
var running = false 
var max_run_stamina = 100
var run_stamina = max_run_stamina
var run_loss = 20 # stamina drain per second
var run_regen = 10 # stamina regen per second
var run_cooldown = true


func _ready():
	update_animation()


func _physics_process(delta):
	if global.player_health <= 0:
		die()

	player_movement(delta)
	attack()
	enemy_attack()
	# update_healthbar()
	current_camera()


func player():
	pass


func player_movement(delta):
	if current_state != State.ATTACK:
		var move_speed = walk_speed
		if Input.is_action_pressed("run") and run_stamina > 0 and run_cooldown: 
			move_speed = run_speed
			current_state = State.RUN
			running = true
		elif Input.is_action_just_released("run") or run_stamina <= 0:
			running = false
		else:
			current_state = State.WALK

		if Input.is_action_pressed("ui_right"):
			current_direction = Direction.RIGHT
			if !playerWalkingAudio.playing:
				playerWalkingAudio.play()
			velocity.x = move_speed
			velocity.y = 0
			
		elif Input.is_action_pressed("ui_left"):
			current_direction = Direction.LEFT
			velocity.x = -move_speed
			velocity.y = 0
			if !playerWalkingAudio.playing:
				playerWalkingAudio.play()
		elif Input.is_action_pressed("ui_down"):
			current_direction = Direction.DOWN
			velocity.y = move_speed
			velocity.x = 0
			if !playerWalkingAudio.playing:
				playerWalkingAudio.play()
		elif Input.is_action_pressed("ui_up"):
			current_direction = Direction.UP
			velocity.y = -move_speed
			velocity.x = 0
			if !playerWalkingAudio.playing:
				playerWalkingAudio.play()
		else:
			current_state = State.IDLE
			velocity.y = 0
			velocity.x = 0
			playerWalkingAudio.stop()
		
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
		global.player_health = global.player_health - 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(global.player_health)
		if !playerHurtAudio.playing:
				playerHurtAudio.play()


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func attack():
	if Input.is_action_just_pressed("attack"):
		current_state = State.ATTACK
		velocity = Vector2() # stops movement during attack
		global.player_active_attack = true
		update_animation()
		$deal_attack_timer.start()
		if !playerAttackAudio.playing:
				playerAttackAudio.play()
		


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_active_attack = false
	current_state = State.IDLE 


func current_camera():
	if global.current_scene == "river_map":
		$river_camera.enabled = true
		$forest_camera.enabled = false
	elif global.current_scene == "forest_map":
		$river_camera.enabled = false
		$forest_camera.enabled = true


func die():
	global.player_health = 0
	alive = false
	current_state = State.DEAD
	update_animation()
	print("Player has been killed.")
	self.queue_free() 
	if !player_death_sound.playing:
				player_death_sound.play()


func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = global.player_health
	
	if global.player_health >= 100 or global.current_scene == "river_map":
		healthbar.visible = false
	else:
		healthbar.visible = true 
		
	if global.player_health <= 10:
		if !player_low_health.playing:
				player_low_health.play()


func update_runbar():
	var runbar = $runbar
	runbar.value = run_stamina  
	runbar.max_value = 100
	
	if current_state == State.RUN or run_stamina < 100:
		runbar.visible = true
	else:
		runbar.visible = false


func _on_run_timer_timeout():
	if running and run_stamina > 0:
		run_stamina -= run_loss * 0.1  # adjust for timer frequency
		if run_stamina < 0:
			run_stamina = 0
			running = false  # automatically stop running if stamina depletes
			run_cooldown = false
			$run_cooldown.start()
	elif running != true and run_stamina < max_run_stamina: # stamina regen
		run_stamina += run_regen * 0.1  # Regenerate stamina
		if run_stamina > max_run_stamina:
			run_stamina = max_run_stamina
	update_runbar()
	if run_stamina < 5:
		if !player_out_run.playing:
				player_out_run.play()



func _on_run_cooldown_timeout():
	run_cooldown = true

# inventory functions
func collect(item, amount: int = 1):
	inventory.insert(item, amount)

func allocate_item(item, amount: int = 1):
	inventory.remove(item, amount)
