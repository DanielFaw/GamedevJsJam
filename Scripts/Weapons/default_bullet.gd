extends Node2D
class_name DefaultBullet

var weapon_resource : WeaponResource
var die_sound : AudioStream = preload("res://Audio/impactWood_light_002.ogg")

var aim_dir := Vector2.ZERO
var spawn_pos := Vector2.ZERO

var damage := 1.0
var speed := 1.0
var size := 1.0
var area_size := 1.0
var pierce := 0
var explodes := false
var explode_damage := 1.0
var explode_range := 1.0
var lifetime := 1.0



func _init(stats : WeaponResource, pos : Vector2, dir : Vector2) -> void:
	weapon_resource = stats
	aim_dir = dir
	spawn_pos = pos
	
	damage = stats.bullet_damage
	speed = stats.bullet_speed
	pierce = stats.bullet_pierce
	explodes = stats.bullet_explodes
	explode_damage = stats.bullet_explode_damage
	explode_range = stats.bullet_explode_range
	lifetime = stats.bullet_lifetime
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = load(weapon_resource.bullet_sprite_path)
	sprite.scale = Vector2(weapon_resource.bullet_sprite_size * 2, weapon_resource.bullet_sprite_size / 4)
	add_child(sprite)
	
	var area := Area2D.new()
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = weapon_resource.bullet_area_size
	collision.shape = shape
	area.add_child(collision)
	
	area.collision_layer = 16
	area.collision_mask = 8
	if weapon_resource.is_enemy_bullet:
		area.collision_layer += 16
		area.collision_mask -= 4
		sprite.modulate = Color.ORANGE_RED
		pass
	else:
		sprite.modulate = Color.SKY_BLUE
	area.collision_mask += 2
	area.body_entered.connect(hit)
	area.area_entered.connect(hit)
	add_child(area)
	
	global_position = spawn_pos
	sprite.look_at(global_position + aim_dir)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	lifetime -= delta
	if lifetime < 0:
		die_action()
	pass

func _physics_process(delta : float) -> void:
	#Move the bullet
	position += aim_dir * (speed * delta)
	pass

func hit(body : Node2D) -> void:
	if body.get_parent().has_signal("took_damage"):
		print("oof!")
		var src := DamageSource.new(weapon_resource, self, damage)
		body.get_parent().take_damage(src)
		pass
	else:
		#Hit a wall, die
		hit_wall()
	pass

func hit_wall() -> void:
	var src := AudioStreamPlayer2D.new()
	src.stream = die_sound
	get_parent().add_child(src)
	src.position = global_position
	src.volume_db = 5
	src.play()
	src.finished.connect(func() -> void: src.queue_free())
	die_action()
	pass

func die_action() -> void:
	try_explode()
	queue_free()
	pass

func try_explode() -> void:
	if explodes:
		
		pass
	pass
