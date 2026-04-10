extends Area2D

@export var speed: float = 300.0
@export var rotation_speed: float = 2.0

func _process(delta):
	# move downward
	position.y += speed * delta
	
	rotation += rotation_speed * delta
	


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
