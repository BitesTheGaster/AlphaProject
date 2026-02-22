class_name IdlePlayerState
extends PlayerState
##


func _ready() -> void:
	name = "idle"


func update(delta: float) -> void:
	player.input_dir = Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Up", "Down")
	)
	
	if player.input_dir:
		state_machine.change_state("move")
	
	player.animation_tree.set("parameters/Idle/blend_position", 
			player.last_dir)
	
	if Input.is_action_just_pressed("Attack"):
		state_machine.change_state("attack")



func physics_update(delta: float) -> void:
	
	player.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Force Continuous
	player.animation_tree.set("callback_mode_discrete", 2)
	
	player.animation_tree.set("parameters/conditions/idle", true)
	player.animation_tree.set("parameters/conditions/run", false)
	player.animation_tree.set("parameters/conditions/attack", false)

func exit() -> void:
	pass
