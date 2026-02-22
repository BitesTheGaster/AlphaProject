class_name Player
extends CharacterBody2D
## Main player script

signal taken_damage()

var stats: PlayerStats = preload("res://player/player_stats.tres")
var last_dir := Vector2.DOWN
var input_dir: Vector2

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var sprite: AnimatedSprite2D = %Sprite


func _ready() -> void:
	sprite.play("IdleDown")
	animation_tree.active = true
