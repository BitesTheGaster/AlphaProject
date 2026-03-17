class_name PlayerStats
extends Resource
##

@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var weapon_stats: WeaponStats = WeaponStats.new().duplicate()
@export var current_debuffs: Array[Debuff] = [
	
]
@export var luck: float = 0.5
