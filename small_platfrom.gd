extends StaticBody2D

@onready var timer = $Timer
@onready var colorect = $ColorRect
@onready var collision = $CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Using groups is usually safer than checking the node name "player"
	if body.is_in_group("player") or body.name == "player":
		# Check if the timer is already running so we don't restart it 
		# every frame the player touches the platform.
		if timer.is_stopped():
			timer.start()

func _on_timer_timeout():
	# Make the platform vanish
	colorect.visible = false
	# We use set_deferred because changing physics state during a 
	# collision callback can cause errors.
	collision.set_deferred("disabled", true)
	
	# Wait for 3 seconds before coming back
	await get_tree().create_timer(3.0).timeout 
	respawn()
	
func respawn():
	colorect.visible = true
	collision.set_deferred("disabled", false)
		
