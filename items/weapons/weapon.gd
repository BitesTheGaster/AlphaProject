class_name Weapon
extends EquipableItem
##

@export var weapon_stats: WeaponStats


func equip(target: CharacterBody2D):
	if (target is Player) or (target is Enemy):
		target.stats.weapon_stats = weapon_stats
		target.update_attack_hitbox()
