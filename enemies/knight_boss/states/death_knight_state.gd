class_name DeathKnightState
extends EnemyState
##


func _ready() -> void:
	name = "death"


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Dominant
	enemy.animation_tree.set("callback_mode_discrete", 0)
	
	enemy.animation_tree.set("parameters/Death/blend_position", 
			enemy.last_dir)
	
	enemy.animation_tree.set("parameters/conditions/idle", false)
	enemy.animation_tree.set("parameters/conditions/run", false)
	enemy.animation_tree.set("parameters/conditions/attack", false)
	enemy.animation_tree.set("parameters/conditions/death", true)
	
	enemy.dead_time.start()
	
	enemy.collision.set_deferred("disabled", true)


func exit() -> void:
	pass
