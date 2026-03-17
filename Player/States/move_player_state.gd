class_name MovePlayerState
extends PlayerState
##


func _ready() -> void:
	name = "move"


func update(delta: float) -> void:
	player.pressed_dir = Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Up", "Down")
	).normalized()
	
	player.animation_tree.set("parameters/Run/blend_position", 
			player.look_dir)
	
	if Input.is_action_just_pressed("Attack"):
		player.velocity = Vector2.ZERO
		state_machine.change_state("attack")

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.move_toward(
			player.stats.movement_component.get_speed(player.look_dir, player.pressed_dir),
			player.stats.movement_component.acel_speed)
	if not player.velocity:
		state_machine.change_state("idle")
	
	player.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Force Continuous
	player.animation_tree.set("callback_mode_discrete", 2)
	
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/run", true)
	player.animation_tree.set("parameters/conditions/attack", false)


func exit() -> void:
	pass
