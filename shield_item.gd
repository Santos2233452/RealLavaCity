extends Area2D

# 1. In the Inspector, drag your ShieldBubble.tscn into this slot
@export var bubble_scene: PackedScene 
@export var shield_duration: float = 10.0

func _on_body_entered(body: Node2D) -> void:
	# Check if the thing that touched the item is the player
	if body.is_in_group("player") or body.has_method("take_damage"):
		
		# 2. Check if the player ALREADY has a shield
		if body.has_node("ActiveShield"):
			# If they do, just find it and reset its timer
			var existing_shield = body.get_node("ActiveShield")
			if existing_shield.has_method("start_shield"):
				existing_shield.start_shield(shield_duration)
		else:
			# 3. If they don't, create a new one
			var bubble = bubble_scene.instantiate()
			
			# CRITICAL: This name must match the player's has_node() check!
			bubble.name = "ActiveShield" 
			
			# 4. Attach it to the player and center it
			body.add_child(bubble)
			bubble.position = Vector2.ZERO 
			
			# 5. Tell the bubble to start its countdown
			if bubble.has_method("start_shield"):
				bubble.start_shield(shield_duration)
		
		# 6. Remove the pickup item from the world
		queue_free()
