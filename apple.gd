extends Node2D

var apple = null
var has_apple = false

func _ready():
   
	var detection_area = $Area2D
	detection_area.connect("body_entered", self, "_on_body_entered")
	detection_area.connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.is_in_group("pickable") and not has_apple:
		apple = body
		print("Apple detected! Press 'E' to pick up.")

func _on_body_exited(body):
	if body == apple:
		apple = null
		print("Apple out of range.")

func _input(event):
	if event.is_action_pressed("ui_accept") and apple and not has_apple:
		pick_up_apple()

func pick_up_apple():
	if apple:
		apple.hide()  # or apple.queue_free() if you want to remove it
		has_apple = true
		print("Apple picked up!")
		
