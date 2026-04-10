extends Area2D

@export var speed: float = 800.0

func _physics_process(delta: float):
	# Move forward in the direction the bullet is facing
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free() # Destroy bullet on impact
	
