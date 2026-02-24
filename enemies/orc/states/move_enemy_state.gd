class_name MoveOrcState
extends EnemyState
##


func _ready() -> void:
	name = "move"


func update(delta: float) -> void:
	if not enemy.target:
		state_machine.change_state("idle")
	else:
		enemy.go_to(enemy.target.global_position)



func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(
			enemy.move_dir, enemy.stats.speed)
	
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	enemy.animation_player.play("Run")


func exit() -> void:
	pass
