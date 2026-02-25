class_name Player
extends CharacterBody2D
## Main player script

signal health_changed(health: int)
signal open_inventory()
signal close_inventory()

var stats: PlayerStats = preload("res://resources/player_stats.tres")\
		.duplicate()
var last_dir := Vector2.DOWN
var input_dir: Vector2
var inventory_opened: bool = false

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var hair: AnimatedSprite2D = %Hair
@onready var pants: AnimatedSprite2D = %Pants
@onready var shirt: AnimatedSprite2D = %Shirt
@onready var attack: AnimatedSprite2D = %Attack
@onready var attack_length: Timer = %AttackLength
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var state_machine: PlayerStateMachine = %PlayerStateMachine
@onready var attack_hibox_down: CollisionShape2D = %Down
@onready var attack_hibox_left: CollisionShape2D = %Left
@onready var attack_hibox_right: CollisionShape2D = %Right
@onready var attack_hibox_up: CollisionShape2D = %Up
@onready var attack_start: Timer = %AttackStart
@onready var attack_end: Timer = %AttackEnd


func _ready() -> void:	
	sprite.play("IdleDown")
	hair.play("IdleDown")
	pants.play("IdleDown")
	shirt.play("IdleDown")
	attack.play("Nothing")
	animation_tree.active = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory") and \
			not inventory_opened and \
			state_machine.current_state.name != "attack":
		inventory_opened = true
		open_inventory.emit()

	elif (Input.is_action_just_pressed("ui_cancel") or \
			Input.is_action_just_pressed("Inventory")) and \
			inventory_opened:
		inventory_opened = false
		close_inventory.emit()
	
	if state_machine.current_state.name != "attack" and \
			attack.animation != "Nothing":
		attack.play("Nothing")
	
	update_debuffs(delta)


func take_damage(damage: int):
	if stats.health <= 0:
		return
	stats.health -= damage
	health_changed.emit(stats.health)
	if stats.health <= 0:
		state_machine.change_state("death")


func take_damage_from_weapon(weapon_stats: WeaponStats):
	if stats.health <= 0:
		return
	stats.health -= weapon_stats.damage
	for debuff in weapon_stats.applied_debuffs:
		stats.current_debuffs.append(debuff.duplicate())
	health_changed.emit(stats.health)
	if stats.health <= 0:
		state_machine.change_state("death")


func update_attack_hitbox():
	attack_hibox_down.shape.set("size", stats.weapon_stats.hitbox)
	attack_hibox_left.shape.set("size",
			Vector2(
					stats.weapon_stats.hitbox.y,
					stats.weapon_stats.hitbox.x))
	attack_hibox_right.shape.set("size",
			Vector2(
					stats.weapon_stats.hitbox.y,
					stats.weapon_stats.hitbox.x))
	attack_hibox_up.shape.set("size", stats.weapon_stats.hitbox)
	var pos: float = stats.weapon_stats.hitbox.y/2
	attack_hibox_down.position = Vector2(0, pos)
	attack_hibox_left.position = Vector2(-pos, 0)
	attack_hibox_right.position = Vector2(pos, 0)
	attack_hibox_up.position = Vector2(0, -pos)
	attack_hibox_down.set_deferred("disabled", true)
	attack_hibox_left.set_deferred("disabled", true)
	attack_hibox_right.set_deferred("disabled", true)
	attack_hibox_up.set_deferred("disabled", true)


func _on_death_time_timeout() -> void:
	
	self.queue_free()


func update_debuffs(delta: float):
	for debuff in stats.current_debuffs:
		debuff.apply_debuff(self, delta)
		if not debuff.is_active():
			stats.current_debuffs.erase(debuff)
