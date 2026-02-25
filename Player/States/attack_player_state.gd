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
	
	player.animation_tree.set("parameters/Attack/blend_position", 
			player.last_dir)
	
	player.sprite.speed_scale = player.stats.weapon_stats.speed
	player.hair.speed_scale = player.stats.weapon_stats.speed
	player.pants.speed_scale = player.stats.weapon_stats.speed
	player.shirt.speed_scale = player.stats.weapon_stats.speed
	player.attack.speed_scale = player.stats.weapon_stats.speed
	player.animation_player.speed_scale = player.stats.weapon_stats.speed
	
	player.close_inventory.emit()
	
	player.animation_tree.set("parameters/conditions/idle", false)
	player.animation_tree.set("parameters/conditions/run", false)
	player.animation_tree.set("parameters/conditions/attack", true)
	
	player.attack_length.wait_time = 0.875/player.stats.weapon_stats.speed
	player.attack_start.wait_time = 0.375/player.stats.weapon_stats.speed
	player.attack_end.wait_time = 0.75/player.stats.weapon_stats.speed
	
	player.attack_length.start()
	player.attack_start.start()
	player.attack_end.start()

func exit() -> void:
	player.sprite.speed_scale = 1
	player.hair.speed_scale = 1
	player.pants.speed_scale = 1
	player.shirt.speed_scale = 1
	player.attack.speed_scale = 1
	player.animation_player.speed_scale = 1
	player.attack.play("Nothing")
	
	player.attack_hibox_down.set_deferred("disabled", true)
	player.attack_hibox_left.set_deferred("disabled", true)
	player.attack_hibox_right.set_deferred("disabled", true)
	player.attack_hibox_up.set_deferred("disabled", true)


func _on_attack_length_timeout() -> void:
	if state_machine.current_state.name == "attack":
		state_machine.change_state("idle")


func _on_sword_attacks_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage_from_weapon(player.stats.weapon_stats)


func _on_attack_end_timeout() -> void:
	player.attack_hibox_down.set_deferred("disabled", true)
	player.attack_hibox_left.set_deferred("disabled", true)
	player.attack_hibox_right.set_deferred("disabled", true)
	player.attack_hibox_up.set_deferred("disabled", true)


func _on_attack_start_timeout() -> void:
	if state_machine.current_state.name != "attack":
		return
	
	if player.sprite.animation == "AttackDown":
		player.attack_hibox_down.set_deferred("disabled", false)
	elif player.sprite.animation == "AttackLeft":
		player.attack_hibox_left.set_deferred("disabled", false)
	elif player.sprite.animation == "AttackRight":
		player.attack_hibox_right.set_deferred("disabled", false)
	elif player.sprite.animation == "AttackUp":
		player.attack_hibox_up.set_deferred("disabled", false)
