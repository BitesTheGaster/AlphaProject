class_name OrcEnemy
extends Enemy
##

signal died(global_pos: Vector2, item: Item)

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var axe_attacks: Area2D = %AxeAttacks
@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var wander_time: Timer = %WanderTime
@onready var wait_time: Timer = %WaitTime
@onready var attack_length: Timer = %AttackLength
@onready var hit_range: Area2D = %HitRange
@onready var hit_range_collision: CollisionShape2D = %HitRangeCollision
@onready var dead_time: Timer = %DeadTime
@onready var hurt_anim: Timer = %HurtAnim
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var axe_collision: CollisionShape2D = %AxeCollisionShape


func _ready() -> void:
	stats = preload("res://resources/orc_stats.tres")
	
	axe_collision.set_deferred("disabled", true)
	
	sprite.play("Idle")
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed)
	
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health


func _process(delta: float) -> void:
	# Flip enemy
	if state_machine.current_state.name != "attack":
		if move_dir.x < 0:
			sprite.flip_h = true
			axe_attacks.scale = Vector2(-1, 1)
		elif move_dir.x > 0:
			sprite.flip_h = false
			axe_attacks.scale = Vector2.ONE
	
	update_debuffs(delta)


func _physics_process(delta: float) -> void:
	update_nav_velocity()


func _on_agro_range_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_agro_range_body_exited(body: Node2D) -> void:
	if body is Player:
		target = 0


func _on_hit_range_body_entered(body: Node2D) -> void:
	if body is Player and state_machine.current_state.name != "hurt" and \
			state_machine.current_state.name != "death":
		state_machine.change_state("attack")


func _on_dead_time_timeout() -> void:
	died.emit(global_position, Global.weapons[Global.IRON_AXE])
	self.queue_free()


func take_damage(damage: int):
	if stats.health <= 0:
		return
	stats.health -= damage
	health_bar.value = stats.health
	if stats.health <= 0:
		state_machine.change_state("death")


func take_damage_from_weapon(weapon_stats: WeaponStats):
	if stats.health <= 0:
		return
	stats.health -= weapon_stats.damage
	for debuff in weapon_stats.applied_debuffs:
		stats.current_debuffs.append(debuff.duplicate())
	state_machine.change_state("hurt")
	health_bar.value = stats.health
	if stats.health <= 0:
		state_machine.change_state("death")
