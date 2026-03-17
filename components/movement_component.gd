class_name MovementComponent
extends Resource
##

@export var forward_speed: float = 80.0
@export var back_speed: float = 50.0
@export var side_speed: float = 66.0
@export var acel_speed: float = 70.0

var speed_mults: Array[float] = [1.0]

func get_speed(look_dir: Vector2, pressed_dir: Vector2) -> Vector2:
	if not pressed_dir:
		return Vector2.ZERO
	
	
	var return_speed = pressed_dir
	
	var f_speed := forward_speed
	var b_speed := back_speed
	var s_speed := side_speed
	
	for mult in speed_mults:
		f_speed *= mult
		b_speed *= mult
		s_speed *= mult
	
	if look_dir == Vector2.UP:
		if pressed_dir.y < 0:
			return_speed.y *= f_speed
		elif pressed_dir.y > 0:
			return_speed.y *= b_speed
		if pressed_dir.x:
			return_speed.x *= s_speed
	elif look_dir == Vector2.DOWN:
		if pressed_dir.y > 0:
			return_speed.y *= f_speed
		elif pressed_dir.y < 0:
			return_speed.y *= b_speed
		if pressed_dir.x:
			return_speed.x *= s_speed
	elif look_dir == Vector2.RIGHT:
		if pressed_dir.x > 0:
			return_speed.x *= f_speed
		elif pressed_dir.x < 0:
			return_speed.x *= b_speed
		if pressed_dir.y:
			return_speed.y *= s_speed
	elif look_dir == Vector2.LEFT:
		if pressed_dir.x < 0:
			return_speed.x *= f_speed
		elif pressed_dir.x > 0:
			return_speed.x *= b_speed
		if pressed_dir.y:
			return_speed.y *= s_speed
	
	return return_speed
