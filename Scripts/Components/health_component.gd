extends Node2D
class_name HealthComponent

var current_health := 100
var max_health := 100
@export var stats : EntityStats
@export var invuln_time := 0.1

@onready var collider : Area2D = $Area2D

var invulnerable := false
var invuln_counter := 0.0

signal took_damage(ds : DamageSource)
signal died()

func _ready() -> void:
	assert(collider.collision_mask + collider.collision_layer > 0, "You need to enable editable children and set collision layers!")
	current_health = stats.health
	max_health = stats.health
	pass

func _process(delta : float) -> void:
	if !invulnerable:
		return
	invuln_counter += delta
	if invuln_counter > invuln_time:
		invulnerable = false
		invuln_counter = 0
	pass

func take_damage(src : DamageSource) -> void:
	if invulnerable:
		return
	current_health -= src.damage
	if current_health <= 0:
		died.emit()
		return
	took_damage.emit(src)
	invulnerable = true
	pass
