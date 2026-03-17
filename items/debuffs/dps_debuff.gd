class_name DPSDebuff
extends Debuff
##

@export var damage: int
@export var delay: float


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
	if time > delay:
		time -= delay
		if target is Enemy or target is Player:
			if damage > 0:
				target.take_damage(damage)
			else:
				target.heal(-damage)
