class_name FireDebuff
extends Debuff
##

@export var start_damage: int = 1

var current_damage: int = start_damage


func apply_debuff(target: CharacterBody2D, delta: float):
	if duration <= 0:
		return
	duration -= delta
	time += delta
	if time > delay:
		time -= delay
		if target is Enemy or target is Player:
			target.take_damage(current_damage)
			current_damage += 1
