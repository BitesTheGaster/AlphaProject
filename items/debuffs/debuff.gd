class_name Debuff
extends Resource
##

@export var duration: float = 1.0
@export var delay: float = 0.5

var time: float = 0.0

func apply_debuff(target: CharacterBody2D, delta: float):
	if duration <= 0:
		return
	duration -= delta
	time += delta
	if time >= delay:
		time -= delay
		# some code

func is_active() -> bool:
	return duration > 0
