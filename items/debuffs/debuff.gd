class_name Debuff
extends Resource
##

@export var duration: float
@export var color: Color = Color.WHITE

var time: float = 0.0
var entered: bool = false


func enter(target: CharacterBody2D):
	# some code
	
	entered = true


func exit(target: CharacterBody2D):
	pass


func apply_debuff(target: CharacterBody2D, delta: float):
	if duration <= 0:
		return
	duration -= delta
	time += delta

func is_active() -> bool:
	return duration > 0
