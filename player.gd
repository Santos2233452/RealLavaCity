extends CharacterBody2D

# Movement and Stats
@export var speed = 400

var health = 100
var health_max = 100 
var player_alive = true
var attack_ip = false 
var current_dir = "down" 


var enemy_inattack_range = false
var enemy_attack_cooldown = true 

func _physics_process(_delta):
	if player_alive:
		get_input()
		move_and_slide()
		enemy_attack_logic()
		check_death()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	
	if input_direction.x > 0: current_dir = "right"
	elif input_direction.x < 0: current_dir = "left"
	elif input_direction.y > 0: current_dir = "down"
	elif input_direction.y < 0: current_dir = "up"

	if position.y > 900:
		get_tree().change_scene_to_file("res://play_again.tscn")

	if Input.is_action_just_pressed("attack") and not attack_ip:
		attack()

func attack():
	attack_ip = true
	print("Attacking: ", current_dir)
	$deal_attack_timer.start() 

func enemy_attack_logic():
	if enemy_inattack_range and enemy_attack_cooldown:
		take_damage(20) 

func check_death():
	if health <= 0 and player_alive:
		player_alive = false
		health = 0
		print("Player has been killed")
		# Switch to the play again screen
		get_tree().change_scene_to_file("res://play_again.tscn")



# This handles the Saw Blade's specific call
func hit(direction):
	if player_alive:
		# 1. Apply Damage
		health -= 20
		print("Hit by saw! Health: ", health)
		
		# 2. Apply Knockback 
		# We force the velocity based on the direction the saw calculated
		velocity.x = direction * 800
		velocity.y = -200
		
		# 3. Visual Feedback
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
		
		check_death()

# Helper for standard enemy attacks
func take_damage(amount):
	health -= amount
	enemy_attack_cooldown = false
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
