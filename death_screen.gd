extends CanvasLayer

func _ready():
	print("DeathScreen is ready and waiting...")
	hide() 

func show_death_screen():
	print("SIGNAL RECEIVED! Attempting to show screen...") # <--- If you don't see this, the signal failed
	show()
	get_tree().paused = true

func _on_restart_button_pressed():
	print("Restart button clicked!")
	get_tree().paused = false 
	get_tree().reload_current_scene()
