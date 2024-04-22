extends Node2D
class_name BasicEnemy

@export var attack_distance := 1000.0

@onready var weapon : WeaponPresenter = $WeaponPresenter
@onready var player : Player = SceneResources.get_resource("Player")
@onready var health_comp : HealthComponent = $health_component
@export var flash : WeaponFlash

func _ready() -> void:
	weapon.attacked.connect(flash.flash)
	health_comp.took_damage.connect(took_damage)
	health_comp.died.connect(died)
	pass

func _process(delta : float) -> void:
	weapon.weapon_cooldown_manager.is_firing = global_position.distance_to(player.global_position) < attack_distance
	weapon.set_aim_dir(global_position.direction_to(player.global_position))
	
	pass

func died() -> void:
	queue_free()
	pass

func took_damage(src : DamageSource) -> void:
	modulate = Color.RED
	await get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.1).finished
	pass
