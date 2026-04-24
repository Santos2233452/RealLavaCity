extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		visible = true
		get_tree().paused = true


func _on_continue_pressed() -> void:
	hide()
	get_tree().puased = false 


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
