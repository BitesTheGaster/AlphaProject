class_name MovePlayerState
extends PlayerState
##


func _ready() -> void:
	name = "move"


func update(delta: float) -> void:
	player.input_dir = Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Up", "Down")
	).normalized()
	
	if Input.is_action_pressed("Right"):
		player.last_dir = Vector2.RIGHT
	elif Input.is_action_pressed("Left"):
		player.last_dir = Vector2.LEFT
	elif Input.is_action_pressed("Down"):
		player.last_dir = Vector2.DOWN
	elif Input.is_action_pressed("Up"):
		player.last_dir = Vector2.UP
	
	player.animation_tree.set("parameters/Run/blend_position", 
			player.last_dir)
	
	if Input.is_action_just_pressed("Attack"):
		player.velocity = Vector2.ZERO
		state_machine.change_state("attack")

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.move_toward(
			player.input_dir*player.stats.speed, player.stats.speed)
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
