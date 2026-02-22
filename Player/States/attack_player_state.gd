class_name AttackPlayerState
extends PlayerState
##


func _ready() -> void:
	name = "attack"


func update(delta: float) -> void:
	pass



func physics_update(delta: float) -> void:
	
	player.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	# Dominant
	player.animation_tree.set("callback_mode_discrete", 0)
	
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/run", false)
	player.animation_tree.set("parameters/conditions/attack", true)
	
	player.animation_tree.set("parameters/Attack/blend_position", 
			player.last_dir)
	
	player.attack_length.start()

func exit() -> void:
	pass


func _on_attack_length_timeout() -> void:
	state_machine.change_state("idle")


func _on_sword_attacks_body_entered(body: Node2D) -> void:
	if body is Enemy:
		# Пока что только 1 урон так как ресурс оружия ещё не сделан
		body.take_damage(1)
