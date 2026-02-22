class_name Enemy
extends CharacterBody2D
##

@export var nav_agent: NavigationAgent2D
var stats: EnemyStats = preload("res://enemies/enemy_stats.tres").duplicate()


func take_damage(damage: int):
	stats.health -= damage
