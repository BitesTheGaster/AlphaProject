class_name KnightBoss
extends Enemy
##

signal died(global_pos: Vector2, loot_table_name: LootManager.Names)

var last_dir := Vector2.DOWN

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var attack: Area2D = %PunchAttack
@onready var state_machine: EnemyStateMachine = %EnemyStateMachine
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_length: Timer = %AttackLength
@onready var hit_range: Area2D = %HitRange
@onready var hit_range_collision: CollisionShape2D = %HitRangeCollision
@onready var dead_time: Timer = %DeadTime
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var attack_collision: CollisionShape2D = %AttackCollisionShape
@onready var attack_start: Timer = %AttackStart
@onready var attack_end: Timer = %AttackEnd
@onready var attack_particles: CPUParticles2D = %AttackParticles


func _ready() -> void:
	stats = preload("res://resources/knight_boss_stats.tres").duplicate()
	attack_collision.set_deferred("disabled", true)
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed)
	animation_tree.active = true

func _process(delta: float) -> void:
	attack.rotation = last_dir.angle()
	update_debuffs(delta)


func _physics_process(delta: float) -> void:
	update_nav_velocity()


func set_target(body: Player) -> void:
	target = body


func _on_hit_range_body_entered(body: Node2D) -> void:
	if body is Player and \
			state_machine.current_state.name != "death":
		state_machine.change_state("attack")


func _on_dead_time_timeout() -> void:
	died.emit(global_position, LootManager.KNIGHT_BOSS)
	self.queue_free()


func take_damage(damage: int):
	if stats.health <= 0:
		return
	stats.health -= damage
	if stats.health <= 0:
		state_machine.change_state("death")


func take_damage_from_weapon(weapon_stats: WeaponStats):
	if stats.health <= 0:
		return
	stats.health -= weapon_stats.damage
	for debuff in weapon_stats.applied_debuffs:
		stats.current_debuffs.append(debuff.duplicate())
	if stats.health <= 0:
		state_machine.change_state("death")
