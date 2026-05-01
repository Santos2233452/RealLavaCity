extends Node2D

func start_shield(duration: float):
	$Timer.wait_time = duration
	$Timer.start()
	
	# Small animation to "pop" in
	scale = Vector2.ZERO
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK)

func _on_timer_timeout():
	# Fade out and then remove itself
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.2)
	await tween.finished
	queue_free()
