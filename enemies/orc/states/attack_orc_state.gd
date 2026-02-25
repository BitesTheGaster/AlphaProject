class_name AttackOrcState
extends EnemyState
##


func _ready() -> void:
	name = "attack"


func update(delta: float) -> void:
	pass



func physics_update(delta: float) -> void:
	
	enemy.move_and_slide()


func update_input(event: InputEvent) -> void:
	pass


func enter() -> void:
	enemy.velocity = Vector2.ZERO
	
	enemy.sprite.speed_scale = enemy.stats.weapon_stats.speed
	enemy.animation_player.speed_scale = enemy.stats.weapon_stats.speed
	
	enemy.animation_player.play("Attack"+str(randi()%2+1))
	
	enemy.attack_length.wait_time = 0.875/enemy.stats.weapon_stats.speed
	enemy.attack_start.wait_time = 0.375/enemy.stats.weapon_stats.speed
	enemy.attack_end.wait_time = 0.625/enemy.stats.weapon_stats.speed
	
	enemy.attack_length.start()
	enemy.attack_start.start()
	enemy.attack_end.start()
	
	enemy.hit_range_collision.set_deferred("disabled", true)
	

func exit() -> void:
	enemy.sprite.speed_scale = 1
	enemy.animation_player.speed_scale = 1
	enemy.animation_player.call_deferred("stop")
	
	enemy.axe_collision.set_deferred("disabled", true)
	enemy.hit_range_collision.set_deferred("disabled", false)


func _on_attack_length_timeout() -> void:
	if state_machine.current_state.name != "death":
		state_machine.change_state("move")


func _on_axe_attacks_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage_from_weapon(enemy.stats.weapon_stats)


func _on_attack_start_timeout() -> void:
	if state_machine.current_state.name == "attack":
		enemy.axe_collision.set_deferred("disabled", false)


func _on_attack_end_timeout() -> void:
	enemy.axe_collision.set_deferred("disabled", true)
