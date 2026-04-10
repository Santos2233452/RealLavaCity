extends Node2D

const bullet_scene = preload("res://bullet.tscn")

@onready var RotationOffest: Node2D = $RotationOffest
@onready var bottom: ColorRect = $bottom
@onready var upthing: ColorRect = $upthing
@onready var Shootpos: Marker2D = $Shootpos
@onready var ShootTimer: Timer = $ShootTimer

var time_between_shot: float = 0.25
var can_shoot: bool = true

func _ready() -> void:
	$ShootTimer.wait_time = time_between_shot
	
	
func _physics_process(delta: float) -> void:
	RotationOffest.rotation = lerp_angle(RotationOffest.rotation, ( get_global_mouse_position() - global_position).angle(), 6.5*delta)
	
	if Input.is_action_just_pressed("Shoot") and can_shoot:
		_shoot()
		can_shoot = false
		$ShootTimer.start()
		
func _shoot():
	pass
	
func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
