class_name IdleOrcState
extends EnemyState
##


func _ready() -> void:
	name = "idle"


func update(delta: float) -> void:
	if enemy.velocity:
		enemy.animation_player.play("Run")
	else:
		enemy.animation_player.play("Idle")
	
	if enemy.target:
		state_machine.change_state("move")



func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(
			enemy.move_dir, enemy.stats.speed)
	
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	enemy.animation_player.play("Idle")
	enemy.velocity = Vector2.ZERO
	enemy.wait_time.start()


func exit() -> void:
	pass


func _on_wander_time_timeout() -> void:
	if state_machine.current_state.name != "idle":
		return
	
	enemy.wait_time.wait_time = randf_range(1, 3)
	enemy.go_to(enemy.global_position)
	enemy.wait_time.start()


func _on_wait_time_timeout() -> void:
	if state_machine.current_state.name != "idle":
		return
	
	enemy.wander_time.wait_time = randf_range(1, 2)
	enemy.go_to(enemy.global_position + Vector2(
			randf_range(-32, 32), randf_range(-32, 32)))
	enemy.wander_time.start()


func _on_navigation_agent_2d_navigation_finished() -> void:
	if enemy.wander_time.is_stopped():
		return
	
	enemy.wander_time.stop()
	enemy.wait_time.start()
