extends CharacterBody2D
class_name Player

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
@onready var player_anim : PlayerAnimationController = $AnimationController
@onready var health_comp : HealthComponent = $health_component

@export var arm_cannon : WeaponPresenter

@export var shoulder_point : Node2D
@export var fire_point : Node2D

var aim_dir := Vector2.ZERO
var moving := false
var weapon_aim_dir := 0.0

func _init() -> void:
	SceneResources.add_resource(self, "Player")
	pass

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	moving = direction != Vector2.ZERO
	#$WeaponHolder.look_at(position + direction)
	if moving:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	player_anim.move_direction = direction
	
	move_and_slide()
	pass

func _process(delta : float) -> void:
	$Camera2D.offset = aim_dir

	arm_cannon.set_aim_dir(shoulder_point.global_position.direction_to(get_global_mouse_position()).normalized())
	pass


func _input(input : InputEvent) -> void:
	if input is InputEventMouseMotion:
		var temp := input as InputEventMouseMotion
		var mult := 2.0
		aim_dir = Vector2(sqrt(temp.position.x * mult) * mult, sqrt(temp.position.y * mult) * mult)
		player_anim.aim_dir = aim_dir.normalized()
	pass
