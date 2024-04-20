extends Node2D
class_name DefaultWeapon

var weapon_stats : WeaponResource

var cooldown := 0.0
var is_firing := false

signal fire()

func _init(stat : WeaponResource) -> void:
	weapon_stats = stat
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	is_firing = Input.is_action_pressed("firing")
	cooldown += delta
	if cooldown >= weapon_stats.attack_cooldown && is_firing:
		fire.emit()
		cooldown = 0
	pass
