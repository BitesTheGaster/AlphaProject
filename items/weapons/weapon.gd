class_name Weapon
extends EquipableItem
##

@export var weapon_stats: WeaponStats


func equip(target: CharacterBody2D):
	if target is Player:
		target.stats.weapon_stats = weapon_stats
