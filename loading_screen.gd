extends Control

@export var loading_bar : ProgressBar
@export var percentage_label : Label

var scene_path : String
var progress : Array

func _ready() -> void:
	scene_path = "res://game.tscn"
	ResourceLoader.load_threaded_request(scene_path)
	
func _process(delta):
	ResourceLoader.load_threaded_get_status(scene_path)
	
	loading_bar.value = progress[0]
	percentage_label.text = str(progress[0] * 100.0)
	
	if loading_bar.value >= 1.0:
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(scene_path)
		)
