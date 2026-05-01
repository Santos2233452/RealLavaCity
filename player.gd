extends CharacterBody2D

# Movement and Stats
@export var speed = 400
@export var jump_velocity = -600.0 

var health = 100
var health_max = 100 
var player_alive = true
var attack_ip = false 
var current_dir = "right" 

var enemy_inattack_range = false
var enemy_attack_cooldown = true 

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if player_alive:
		if not is_on_floor():
			velocity.y += gravity * delta

		get_input()
		move_and_slide()
		enemy_attack_logic()
		check_death()

func get_input():
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		current_dir = "right" if direction > 0 else "left"
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_pressed("attack") and not attack_ip:
		attack()

	if position.y > 900:
		get_tree().change_scene_to_file("res://play_again.tscn")

func attack():
	attack_ip = true
	if has_node("deal_attack_timer"):
		$deal_attack_timer.start() 

func enemy_attack_logic():
	if enemy_inattack_range and enemy_attack_cooldown:
		take_damage(20) 

func check_death():
	if health <= 0 and player_alive:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://play_again.tscn")

# --- UPDATED DAMAGE FUNCTIONS ---

func hit(direction):
	if player_alive:
		# SHIELD CHECK: Skip damage if shield exists
		if has_node("ActiveShield"):
			print("Shield blocked the saw!")
			return
			
		health -= 20
		velocity.x = direction * 800
		velocity.y = -300 
		
		# Visual Feedback
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
		
		check_death()

func take_damage(amount):
	# SHIELD CHECK: Skip damage if shield exists
	if has_node("ActiveShield"):
		print("Shield absorbed the hit!")
		return

	health -= amount
	enemy_attack_cooldown = false
	if has_node("attack_cooldown"):
		$attack_cooldown.start()
	print("Player Health: ", health)
	check_death()

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
