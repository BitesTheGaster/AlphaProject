class_name MainMenu
extends CanvasLayer

@onready var hair: Sprite2D = %Hair
@onready var pants: Sprite2D = %Pants
@onready var shirt: Sprite2D = %Shirt
@onready var player: Sprite2D = %Player
@onready var hair_color: ColorPickerButton = %HairColor
@onready var shirt_color: ColorPickerButton = %ShirtColor
@onready var pants_color: ColorPickerButton = %PantsColor
@onready var start: TextureButton = %Start


func _ready() -> void:
	hair.modulate = hair_color.color
	shirt.modulate = shirt_color.color
	pants.modulate = pants_color.color


func _on_hair_color_color_changed(color: Color) -> void:
	hair.modulate = color


func _on_shirt_color_color_changed(color: Color) -> void:
	shirt.modulate = color


func _on_pants_color_color_changed(color: Color) -> void:
	pants.modulate = color
