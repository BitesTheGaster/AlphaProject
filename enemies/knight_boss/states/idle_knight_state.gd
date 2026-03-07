class_name IdleKnightState
extends EnemyState
##


func _ready() -> void:
	name = "idle"


func update(delta: float) -> void:
	if enemy.target:
		state_machine.change_state("move")
	
	enemy.animation_tree.set("parameters/Idle/blend_position", 
			enemy.last_dir)


func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(
			enemy.move_dir, enemy.stats.speed)
	
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Force Continuous
	enemy.animation_tree.set("callback_mode_discrete", 2)
	
	enemy.animation_tree.set("parameters/conditions/idle", true)
	enemy.animation_tree.set("parameters/conditions/run", false)
	enemy.animation_tree.set("parameters/conditions/attack", false)


func exit() -> void:
	pass
