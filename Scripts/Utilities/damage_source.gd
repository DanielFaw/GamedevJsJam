class_name DamageSource

var stats : WeaponResource
var damage : int
var source : Node

func _init(s : WeaponResource, src : Node, d : int) -> void:
	damage = d
	stats = s
	source = src
	pass
