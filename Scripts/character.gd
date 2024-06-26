extends CharacterBody2D
class_name Player

var speed := 300.0
@onready var player_anim : PlayerAnimationController = $AnimationController
@onready var health_comp : HealthComponent = $health_component

@export var arm_cannon : WeaponPresenter
@export var stats : EntityStats
@export var shoulder_point : Node2D
@export var fire_point : Node2D

var aim_dir := Vector2.ZERO
var moving := false
var weapon_aim_dir := 0.0

func _init() -> void:
	SceneResources.add_resource(self, "Player")
	pass

func _ready() -> void:
	health_comp.took_damage.connect(took_damage)
	speed *= stats.move_speed
	pass

func _physics_process(delta : float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	moving = direction != Vector2.ZERO

	if moving:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	player_anim.move_direction = direction
	
	move_and_slide()
	pass

func _process(delta : float) -> void:
	$Camera2D.offset = aim_dir
	arm_cannon.weapon_cooldown_manager.is_firing = Input.is_action_pressed("firing")
	arm_cannon.set_aim_dir(shoulder_point.global_position.direction_to(get_global_mouse_position()).normalized())
	pass


func _input(input : InputEvent) -> void:
	if input is InputEventMouseMotion:
		var temp := input as InputEventMouseMotion
		var mult := 2.0
		aim_dir = Vector2(sqrt(temp.position.x * mult) * mult, sqrt(temp.position.y * mult) * mult)
		player_anim.aim_dir = aim_dir.normalized()
	pass

func took_damage(src : DamageSource) -> void:
	$HitSound.play()
	modulate = Color.SKY_BLUE
	await get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.25).finished
	pass
