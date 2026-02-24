class_name HurtOrcState
extends EnemyState
##


func _ready() -> void:
	name = "hurt"


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(
			Vector2.ZERO, enemy.stats.speed)
	
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	enemy.animation_player.play("Hurt")
	enemy.hurt_anim.start()

func exit() -> void:
	pass


func _on_hurt_anim_timeout() -> void:
	if state_machine.current_state.name != "death":
		state_machine.change_state("move")
