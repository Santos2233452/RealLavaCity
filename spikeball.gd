extends AnimatableBody2D

@export var fullswing = false
@export var damage_amount = 20

func _ready():
	if fullswing:
		$AnimationPlayer.play("Fullswing")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Spike Ball hit the player!")
		
		
		if body.has_method("hit"):
			
			var knockback_dir = sign(body.global_position.x - global_position.x)
			body.hit(knockback_dir)
		
		
		elif body.has_method("take_damage"):
			body.take_damage(damage_amount)


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
