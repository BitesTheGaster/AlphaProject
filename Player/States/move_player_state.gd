class_name MovePlayerState
extends PlayerState
##


func _ready() -> void:
	name = "move"


func update(delta: float) -> void:
	player.input_dir = Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Up", "Down")
	)
	if player.input_dir:
		player.last_dir = player.input_dir
	
	player.animation_tree.set("parameters/Run/blend_position", 
			player.last_dir)


func physics_update(delta: float) -> void:
	player.velocity = player.velocity.move_toward(
			player.input_dir*player.stats.speed, player.stats.speed)
	if not player.velocity:
		state_machine.change_state("idle")
	
	player.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/run", true)


func exit() -> void:
	pass
