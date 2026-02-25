class_name WeaponStats
extends Resource

@export var damage: int = 10
@export var speed: float = 1
@export var applied_debuffs: Array[Debuff] = [
	
]
@export var hitbox := Vector2(14, 20)
@export var slash_color := Color.WHITE

func _init() -> void:
	for i in range(0, len(applied_debuffs)):
		applied_debuffs[i] = applied_debuffs[i].duplicate()
