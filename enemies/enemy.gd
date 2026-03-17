class_name Enemy
extends CharacterBody2D
##

@export var nav_agent: NavigationAgent2D

var stats: EnemyStats
var move_dir := Vector2.ZERO
var target#: Player
var disabled: bool = true


func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed)


func take_damage(damage: int):
	stats.health -= damage


func take_damage_from_weapon(weapon_stats: WeaponStats):
	stats.health -= weapon_stats.damage
	for debuff in weapon_stats.applied_debuffs:
		stats.current_debuffs.append(debuff.duplicate())


func update_debuffs(delta: float):
	var color = Vector3(1, 1, 1)
	var cnt: int = 1
	for debuff in stats.current_debuffs:
		if not debuff.entered:
			debuff.enter(self)
		debuff.apply_debuff(self, delta)
		if not debuff.is_active():
			debuff.exit(self)
			stats.current_debuffs.erase(debuff)
		color += Vector3(debuff.color.r, debuff.color.g, debuff.color.b)
		cnt += 1
	
	self.modulate = Color(
			(color/cnt).x,
			(color/cnt).y,
			(color/cnt).z
	)

func go_to(pos: Vector2):
	nav_agent.target_position = pos


func _on_nav_agent_velocity_computed(safe_velocity: Vector2):
	if disabled:
		return
	move_dir = safe_velocity


func update_nav_velocity():
	if disabled:
		return
	
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var new_velocity = direction * stats.speed
	nav_agent.velocity = new_velocity
