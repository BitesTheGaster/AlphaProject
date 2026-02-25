class_name DPSDebuff
extends Debuff
##

@export var damage: int


func apply_debuff(target: CharacterBody2D, delta: float):
	if duration <= 0:
		return
	duration -= delta
	time += delta
	if time > delay:
		time -= delay
		if target is Enemy or target is Player:
			target.take_damage(damage)
