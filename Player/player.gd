class_name Player
extends CharacterBody2D
## Main player script

signal taken_damage()

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var sprite: AnimatedSprite2D = %Sprite
