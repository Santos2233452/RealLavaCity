extends Area2D

@export var speed: float = 300.0
@export var rotation_speed: float = 4.0
@export var damage_amount: int = 20

func _process(delta):
	# Move downward
	position.y += speed * delta
	# Spin the meteorite
	
	# Delete if it goes off the bottom of the screen
	if position.y > 1000:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Check if the object the meteorite touched is the player
	if body.has_method("take_damage"):
		body.take_damage(damage_amount) # This calls the function on the Player script
		queue_free() # The meteorite explodes/disappears on impact
