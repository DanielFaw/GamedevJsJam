extends Resource
class_name WeaponResource


@export var sprite_path : String = "res://icon.svg"
@export var name := "Test Weapon"
@export var attack_cooldown := 1.0

@export var bullet_sprite_path : String = "res://icon.svg"
@export var bullet_damage := 1.0
@export var bullet_speed := 1.0
@export var bullet_lifetime := 1.0
@export var bullet_sprite_size := 1.0
@export var bullet_area_size := 1.0
@export var bullet_pierce := 0
@export var bullet_explodes := false
@export var bullet_explode_damage := 1.0
@export var bullet_explode_range := 1.0
@export var is_enemy_bullet := false
