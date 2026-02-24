class_name PlayerStats
extends Resource
##

var speed: float = 70.0
var max_health: int = 100
var health: int = max_health
var weapon_stats: WeaponStats = WeaponStats.new().duplicate()
