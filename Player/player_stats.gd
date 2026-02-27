class_name PlayerStats
extends Resource
##

@export var speed: float = 70.0
@export var max_health: int = 100
var health: int = max_health
@export var weapon_stats: WeaponStats = WeaponStats.new().duplicate()
var current_debuffs: Array[Debuff] = [
	
]
@export var luck: float = 0.5
