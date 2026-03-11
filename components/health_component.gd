class_name HealthComponent
extends Resource
##

@export var max_health: float = 100.0
var current_health: float = max_health
@export var defence: float = 0.0
@export var defence_mult: float = 1.0
@export var defence_bonus: float = 0.0
@export var absolute_defence: float = 0.0
@export var absolute_defence_mult: float = 1.0
@export var absolute_defence_bonus: float = 0.0



# var taken_damage: float = (damage * (1 - (absolute_defence * absolute_defence_mult + absolute_defence_bonus))) \
		# - defence * defence_mult - defence_bonus


func take_damage(damage: int):
	if current_health <= 0:
		return
	var taken_damage: float = (damage * (1 - (absolute_defence * absolute_defence_mult + absolute_defence_bonus))) \
		 - defence * defence_mult - defence_bonus
	current_health -= taken_damage
