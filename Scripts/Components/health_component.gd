extends Node2D
class_name HealthComponent

var current_health := 100
var max_health := 100
@export var stats : EntityStats

@onready var collider : Area2D = $Area2D

signal took_damage(ds : DamageSource)
signal died()

func _ready() -> void:
	assert(collider.collision_mask + collider.collision_layer > 0, "You need to enable editable children and set collision layers!")
	current_health = stats.health
	max_health = stats.health
	pass

func take_damage(src : DamageSource) -> void:
	current_health -= src.damage
	if current_health <= 0:
		died.emit()
		return
	took_damage.emit(src)
	pass
