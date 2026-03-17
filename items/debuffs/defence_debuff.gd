class_name DefenceDebuff
extends Debuff
##

@export var defence_bonus: float
@export var defence_mult: float
@export var absolute_defence_bonus: float
@export var absolute_defence_mult: float


func enter(target: CharacterBody2D):
	if target is Player:
		target.stats.health_component.defence_bonuses.append(defence_bonus)
		target.stats.health_component.defence_mults.append(defence_mult)
		target.stats.health_component.absolute_defence_bonuses.append(absolute_defence_bonus)
		target.stats.health_component.absolute_defence_mults.append(absolute_defence_mult)
	
	entered = true


func exit(target: CharacterBody2D):
	if target is Player:
		target.stats.health_component.defence_bonuses.erase(defence_bonus)
		target.stats.health_component.defence_mults.erase(defence_mult)
		target.stats.health_component.absolute_defence_bonuses.erase(absolute_defence_bonus)
		target.stats.health_component.absolute_defence_mults.erase(absolute_defence_mult)


func apply_debuff(target: CharacterBody2D, delta: float):
	if duration <= 0:
		return
	duration -= delta
	time += delta

func is_active() -> bool:
	return duration > 0
