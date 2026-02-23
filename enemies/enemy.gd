class_name Enemy
extends CharacterBody2D
##

@export var nav_agent: NavigationAgent2D
var stats: EnemyStats = preload("res://resources/enemy_stats.tres")\
		.duplicate()


func take_damage(damage: int):
	stats.health -= damage


func take_damage_from_weapon(weapon_stats: WeaponStats):
	stats.health -= weapon_stats.damage
	for debuff in weapon_stats.applied_debuffs:
		stats.current_debuffs.append(debuff.duplicate())


func update_debuffs(delta: float):
	for debuff in stats.current_debuffs:
		debuff.apply_debuff(self, delta)
		if not debuff.is_active():
			stats.current_debuffs.erase(debuff)
