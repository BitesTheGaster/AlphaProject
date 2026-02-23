class_name DroppedItem
extends Area2D

signal player_entered(dropped_item: DroppedItem, item: Item)

var item: Item
var sprite_texture: Texture2D

@onready var sprite: Sprite2D = %Sprite2D
@onready var collision: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	sprite.texture = sprite_texture


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit(self, item)
