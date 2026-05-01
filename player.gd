extends CharacterBody2D

# Movement and Stats
@export var speed = 400
@export var jump_velocity = -600.0 # Adjust this for jump height

var health = 100
var health_max = 100 
var player_alive = true
var attack_ip = false 
var current_dir = "right" # Changed default to right for platformer

var enemy_inattack_range = false
var enemy_attack_cooldown = true 

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if player_alive:
		# 1. Apply Gravity
		if not is_on_floor():
			velocity.y += gravity * delta

		# 2. Handle Input & Jump
		get_input()
		
		# 3. Apply Movement
		move_and_slide()
		
		# 4. Combat Logic
		enemy_attack_logic()
		check_death()

func get_input():
	# Horizontal movement only (Left/Right)
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		current_dir = "right" if direction > 0 else "left"
	else:
		# Smoothly stop horizontal movement
		velocity.x = move_toward(velocity.x, 0, speed)

	# Handle Jumping (Only if on the floor)
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	# Attack Input
	if Input.is_action_just_pressed("attack") and not attack_ip:
		attack()

	# Fall off map detection
	if position.y > 900:
		get_tree().change_scene_to_file("res://play_again.tscn")

func attack():
	attack_ip = true
	print("Attacking: ", current_dir)
	# Ensure you have a timer node named 'deal_attack_timer'
	if has_node("deal_attack_timer"):
		$deal_attack_timer.start() 

func enemy_attack_logic():
	if enemy_inattack_range and enemy_attack_cooldown:
		take_damage(20) 

func check_death():
	if health <= 0 and player_alive:
		player_alive = false
		health = 0
		print("Player has been killed")
		get_tree().change_scene_to_file("res://play_again.tscn")

# This handles the Saw Blade's specific call
func hit(direction):
	if player_alive:
		health -= 20
		print("Hit by saw! Health: ", health)
		
		# Apply Knockback 
		velocity.x = direction * 800
		velocity.y = -300 # A little pop upwards when hit
		
		# Visual Feedback
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
		
		check_death()

func take_damage(amount):
	health -= amount
	enemy_attack_cooldown = false
	if has_node("attack_cooldown"):
		$attack_cooldown.start()
	print("Player Health: ", health)

# --- Signal Connections ---

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func _on_deal_attack_timer_timeout() -> void:
	attack_ip = false
