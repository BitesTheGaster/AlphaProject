class_name Player
extends CharacterBody2D
## Main player script

signal taken_damage()
signal open_inventory()
signal close_inventory()


var stats: PlayerStats = preload("res://resources/player_stats.tres")\
		.duplicate()
var last_dir := Vector2.DOWN
var input_dir: Vector2
var inventory_opened: bool = false

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var attack_length: Timer = $AttackLength


func _ready() -> void:	
	sprite.play("IdleDown")
	animation_tree.active = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory") and \
			not inventory_opened:
		inventory_opened = true
		open_inventory.emit()

	elif (Input.is_action_just_pressed("ui_cancel") or \
			Input.is_action_just_pressed("Inventory")) and \
			inventory_opened:
		inventory_opened = false
		close_inventory.emit()


func take_damage(weapon_stats: WeaponStats):
	stats.health -= weapon_stats.damage
