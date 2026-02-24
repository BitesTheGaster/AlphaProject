class_name DeathOrcState
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
	enemy.velocity = Vector2.ZERO
	enemy.collision.set_deferred("disabled", true)
	enemy.dead_time.start()
	enemy.animation_player.play("Death")
	


func exit() -> void:
	pass
