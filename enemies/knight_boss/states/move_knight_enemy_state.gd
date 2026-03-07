class_name MoveKnightState
extends EnemyState
##


func _ready() -> void:
	name = "move"


func update(delta: float) -> void:
	if not enemy.target:
		state_machine.change_state("idle")
	else:
		enemy.go_to(enemy.target.global_position)
	
	enemy.animation_tree.set("parameters/Run/blend_position", 
			enemy.last_dir)


func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(
			enemy.move_dir, enemy.stats.speed)
	if enemy.move_dir:
		enemy.last_dir = enemy.move_dir.normalized()
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Force Continuous
	enemy.animation_tree.set("callback_mode_discrete", 2)
	
	enemy.animation_tree.set("parameters/conditions/idle", false)
	enemy.animation_tree.set("parameters/conditions/run", true)
	enemy.animation_tree.set("parameters/conditions/attack", false)


func exit() -> void:
	pass
