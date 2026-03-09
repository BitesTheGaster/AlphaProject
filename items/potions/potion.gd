class_name Potion
extends Item
##

@export var effect: Debuff

func use(target: CharacterBody2D):
	if (target is Player) or (target is Enemy):
		target.stats.current_debuffs.append(effect.duplicate())
