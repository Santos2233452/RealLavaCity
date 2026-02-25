extends CharacterBody2D

# Movement and Stats
@export var speed = 400
var health = 100 
var player_alive = true
var attack_ip = false # Attack In Progress
var current_dir = "down" # Stores which way we are facing

# Combat Logic
var enemy_inattack_range = false
var enemy_attack_cooldown = true # Start as true so the first hit registers

func _physics_process(_delta):
	if player_alive:
		get_input()
		move_and_slide()
		enemy_attack_logic()
		check_death()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	# Update direction for the attack logic
	if input_direction.x > 0:
		current_dir = "right"
	elif input_direction.x < 0:
		current_dir = "left"
	elif input_direction.y > 0:
		current_dir = "down"
	elif input_direction.y < 0:
		current_dir = "up"

	# Listen for attack input (Must be capitalized 'Input')
	if Input.is_action_just_pressed("attack") and not attack_ip:
		attack()

func attack():
	attack_ip = true
	# If you have a global script: global.player_current_attack = true 
	
	print("Attacking: ", current_dir)
	
	# Start the timer to reset the attack state
	$deal_attack_timer.start() 
	
	# This is where you would trigger your AnimationPlayer
	# if current_dir == "right": $AnimationPlayer.play("attack_right")

func enemy_attack_logic():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player Health: ", health)

func check_death():
	if health <= 0:
		player_alive = false
		health = 0
		print("Player has been killed")
		self.queue_free()

# Identification function (keep this at the left margin)
func player():
	pass

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
	# global.player_current_attack = false
	attack_ip = false
