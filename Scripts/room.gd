extends Node2D
class_name Room

@onready var tilemap : TileMap = $TileMap

var room_rect : Rect2i


func _ready() -> void:
	room_rect = tilemap.get_used_rect()
	pass
