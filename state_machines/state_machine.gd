@abstract
class_name StateMachine
extends Node
## Template for state machines

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State]


func _ready() -> void:
	current_state = initial_state
	for child in get_children():
		if child is State:
			states[child.name] = child


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	current_state.update_input(event)


func change_state(new_state: String):
	current_state.exit()
	current_state = states[new_state]
	current_state.enter()
