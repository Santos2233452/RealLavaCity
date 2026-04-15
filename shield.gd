extends Area2D

var shield_active = false
var shield_duration = 5.0  # seconds

func _ready():
	$Shield.visible = false
	$Shield.set_collision_layer_bit(0, false)

func activate_shield():
	shield_active = true
	$Shield.visible = true
	$Shield.set_collision_layer_bit(0, true)
	yield(get_tree().create_timer(shield_duration), "timeout")
	deactivate_shield()

func deactivate_shield():
	shield_active = false
	$Shield.visible = false
	$Shield.set_collision_layer_bit(0, false)

func _on_Shield_body_entered(body):
	
	if body.is_in_group("enemy") or body.is_in_group("projectile"):
		
		body.queue_free()
	  
