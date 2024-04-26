extends CharacterBody2D
class_name BasicEnemy

@export var attack_distance := 1000.0
@export var move_distance := 2000.0
@export var target_distance := 600.0
@export var move_speed := 12000.0

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

func _physics_process(delta : float) -> void:
	var dist_to_player := global_position.distance_to(player.global_position)
	if dist_to_player > move_distance:
		return
	if dist_to_player > target_distance:
		#Move to player
		velocity = global_position.direction_to(player.global_position).normalized() * delta * move_speed
		pass
	elif dist_to_player < target_distance:
		#Move away from player
		velocity = player.global_position.direction_to(global_position).normalized() * delta * move_speed * 0.67
		pass
	else:
		#Stand still
		pass
	move_and_slide()
	pass

func died() -> void:
	queue_free()
	pass

func took_damage(src : DamageSource) -> void:
	modulate = Color.RED
	await get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.1).finished
	pass
