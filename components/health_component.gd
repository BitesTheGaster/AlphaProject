class_name HealthComponent
extends Resource
##

@export var max_health: float = 100.0
var current_health: float = max_health
@export var defence: float = 0.0
@export var defence_mults: Array[float] = [1.0]
@export var defence_bonuses: Array[float] = [0.0]
@export var absolute_defence: float = 0.0
@export var absolute_defence_mults: Array[float] = [1.0]
@export var absolute_defence_bonuses: Array[float] = [0.0]


func take_damage(damage: int):
	if current_health <= 0:
		return
	
	var def := defence
	var abs_def := absolute_defence
	
	for mult in defence_mults:
		def *= mult
	for mult in absolute_defence_mults:
		abs_def *= mult
	for bonus in defence_bonuses:
		def += bonus
	for bonus in absolute_defence_bonuses:
		abs_def += bonus
	var taken_damage: float = max(0, damage * (1 - abs_def) - def)
	
	current_health -= taken_damage


func heal(health_amount: int):
	current_health += health_amount
