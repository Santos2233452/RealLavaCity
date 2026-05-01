extends Control

var target_scene_path = "res://game.tscn"
var progress = []
var min_load_time = 4.0  # Set to 4 seconds
var time_elapsed = 0.0

func _ready():
	$TextureProgressBar.value = 0
	ResourceLoader.load_threaded_request(target_scene_path)

func _process(delta):
	time_elapsed += delta
	
	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Smoothly move the bar
	var actual_progress = progress[0] * 100
	$TextureProgressBar.value = lerp($TextureProgressBar.value, actual_progress, 0.1)
	
	# Check if loading is done AND 4 seconds have passed
	if status == ResourceLoader.THREAD_LOAD_LOADED and time_elapsed >= min_load_time:
		# Force the bar to 100 so it looks finished
		$TextureProgressBar.value = 100 
		
		var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
		get_tree().change_scene_to_packed(new_scene)
