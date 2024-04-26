extends Node2D
class_name WeaponPresenter

#Holds a sprite and a weapon, telling inner weapon about enemies in range and getting passed back 

@export var stats : WeaponResource
@export var fire_point : Node2D
@export var arm_cannon := false

var last_frame := 0
var frame_speed := 0.05
var frame_counter := 0.0
var fired := false

var weapon_cooldown_manager : DefaultWeapon
var fire_dir := Vector2.ZERO
@onready var bullet_container : Node2D = SceneResources.get_resource("BulletContainer")
@onready var sprite : Sprite2D = $Sprite2D
@onready var sound : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal attacked()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if arm_cannon:
		frame_speed *= (stats.attack_cooldown / 0.5)
	weapon_cooldown_manager = DefaultWeapon.new(stats)
	weapon_cooldown_manager.fire.connect(attack)
	add_child(weapon_cooldown_manager)
	
	if !is_instance_valid(fire_point):
		fire_point = Node2D.new()
		add_child(fire_point)
	
	pass # Replace with function body.

func _process(delta : float) -> void:
	look_at(global_position + fire_dir)
	if !arm_cannon:
		return
	if !fired:
		return
	frame_counter += delta
	if frame_counter >= frame_speed:
		frame_counter -= frame_speed
		last_frame += 1
		if last_frame < 6:
			sprite.frame = last_frame
		else:
			fired = false
			last_frame = 0
			sprite.frame = 0
	pass

func set_aim_dir(dir : Vector2) -> void:
	fire_dir = dir
	pass

func attack() -> void:
	#Spawn the projectile defined in the stats
	attacked.emit()
	var bullet := DefaultBullet.new(stats, fire_point.global_position, fire_dir)
	bullet_container.add_child(bullet)
	sound.play()
	fired = true
	frame_counter = 0
	last_frame = 0
	pass
