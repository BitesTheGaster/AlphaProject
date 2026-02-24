class_name DeathPlayerState
extends PlayerState
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
	player.animation_tree.set("parameters/Death/blend_position", 
			player.last_dir)
			
	# Dominant
	player.animation_tree.set("callback_mode_discrete", 0)
	
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/run", false)
	player.animation_tree.set("parameters/conditions/attack", false)
	player.animation_tree.set("parameters/conditions/death", true)


func exit() -> void:
	pass
