class_name EnemyStateMachine
extends StateMachine
## State machine for enemy

@export var enemy: Enemy


func _process(delta: float) -> void:
	current_state.update(delta)
	#


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)
	#


func _unhandled_input(event: InputEvent) -> void:
	current_state.update_input(event)
	#
