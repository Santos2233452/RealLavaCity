extends Area2D


@export var bubble_scene: PackedScene 
@export var duration: float = 5.0

func _on_body_entered(body):
	
	if body.is_in_group("player") or body.has_method("apply_shield"):
		
		var bubble = bubble_scene.instantiate()
		
		
		body.add_child(bubble)
		bubble.name = "ActiveShield" 
		bubble.start_shield(duration)
		
		
		queue_free()
