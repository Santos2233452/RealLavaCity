extends Node2D

@onready var timer = $Timer
@onready var sprite = $Sprite2D

func _ready():
	# Ensure the timer is connected to the timeout function via code
	# so you don't have to do it manually in the editor.
	timer.timeout.connect(_on_timer_timeout)

func start_shield(duration: float = 7.0):
	# 1. Reset visual and timer
	modulate.a = 1.0 
	timer.wait_time = duration
	timer.start()
	
	# 2. Appearance Animation (Pop in)
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK)
	
	# 3. Optional: Make it pulse while active
	var pulse = create_tween().set_loops()
	pulse.tween_property(sprite, "modulate:a", 0.5, 0.5)
	pulse.tween_property(sprite, "modulate:a", 1.0, 0.5)
	
	# Stop pulsing when the timer ends
	timer.timeout.connect(func(): pulse.kill())

func _on_timer_timeout():
	# 4. Disappear Animation
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	
	# 5. Delete from game
	await tween.finished
	queue_free()
