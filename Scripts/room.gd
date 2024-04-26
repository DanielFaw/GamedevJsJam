extends Node2D
class_name Room

var enemy_prefab := preload("res://Prefabs/basic_enemy.tscn")

@onready var tilemap : TileMap = $TileMap
@onready var main_game : MainGame = SceneResources.get_resource("MainGame")
@export var enemy_spawn_chance := 5.0

func _init() -> void:
	
	pass

func spawn_enemies() -> void:
	var spawn_points := tilemap.get_used_cells(0)
	for p in spawn_points:
		#Edges can't be spawned on
		if abs(p.x) == 10 || abs(p.y) == 10: continue
		var td := tilemap.get_cell_tile_data(0, p)
		if !is_instance_valid(td): continue
		if td.get_collision_polygons_count(0) == 0:
			#Chance to spawn enemy
			if randf_range(0, 100) < enemy_spawn_chance:
				var enemy : BasicEnemy = enemy_prefab.instantiate()
				main_game.enemy_container.add_child(enemy)
				enemy.global_position = global_position + (Vector2(p.x, p.y) * 256)
			pass
	pass

func _ready() -> void:

	pass

func _process(delta : float) -> void:
	
	pass
