extends Node2D
class_name WeaponFlash

@export var sprite : Sprite2D


func _ready() -> void:
	sprite.visible = false
	pass

func flash() -> void:
	sprite.visible = true
	sprite.frame = 0
	await get_tree().create_timer(0.05).timeout
	sprite.frame = 1
	await get_tree().create_timer(0.05).timeout
	sprite.visible = false
	pass
