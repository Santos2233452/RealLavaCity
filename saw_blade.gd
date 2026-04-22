extends Node2D

@onready var animated_sprite2d = $AnimatedSprite2D

var moving_left = false

@export var SPEED = 50;
@export var MAX_LEFT = 50;
@export var MAX_RIGHT = 60;

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	pass
	
func move(delta):
	if moving_left:
		animated_sprite2d.position.x -= SPEED * delta
		if animated_sprite2d.position.x < -1 * MAX_LEFT:
			animated_sprite2d.position.x = -1 * MAX_LEFT
			moving_left = false
	else:
		animated_sprite2d.position.x += SPEED * delta
		if animated_sprite2d.position.x > MAX_RIGHT:
			animated_sprite2d.position.x = MAX_RIGHT
			moving_left = true
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var direction = 1
	if body.global_position.x < global_position.x:
		direction = -1
	body.hit(direction)
	pass # Replace with function body.
