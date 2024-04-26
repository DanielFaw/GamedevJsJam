extends Node2D
class_name MainGame

const ROOM_SIZE := 256 * 20


var door_prefab : PackedScene = preload("res://Prefabs/door.tscn")
var room_script := preload("res://Scripts/room.gd")


@export var room_container : Node2D
@export var door_container : Node2D
@export var enemy_container : Node2D

@onready var player : Player = SceneResources.get_resource("Player")

var room_data : Array[RoomDefinition]
var generator : RoomGenerator

var layout := {}

func _init() -> void:
	SceneResources.add_resource(self, "MainGame")
	var dir := DirAccess.open("res://Rooms")
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if ".tres.remap" in file_name:
			file_name = file_name.trim_suffix(".remap")
		var room_def : RoomDefinition = load("res://Rooms/" + file_name)
		room_data.push_back(room_def)
		file_name = dir.get_next()
		pass
	generator = RoomGenerator.new()
	generator.generate(room_data)
	pass

func _ready() -> void:
	#Spawn rooms
	for pos : Vector2i in generator.generated_map.keys():
		var room_def : RoomDefinition = generator.generated_map[pos]
		
		var room : Node2D = room_def.room.instantiate()
		room.set_script(room_script)
		room.global_position = pos * ROOM_SIZE
		room_container.add_child(room)
		if !room_def.spawn_room:
			room.spawn_enemies()
		#room.spawn_enemies()
		#Spawn doors at each location
		if room_def.top_door:
			var door : Door = door_prefab.instantiate()
			door_container.add_child(door)
			door.global_position = (pos * ROOM_SIZE) + (Vector2i.UP * (ROOM_SIZE/2 + 32))
			pass
		if room_def.right_door:
			var door : Door = door_prefab.instantiate()
			door_container.add_child(door)
			door.global_position = (pos * ROOM_SIZE) + (Vector2i.RIGHT * (ROOM_SIZE/2 + 32))
			door.rotation_degrees = 90
			pass
		if room_def.bottom_door:
			var door : Door = door_prefab.instantiate()
			door_container.add_child(door)
			door.global_position = (pos * ROOM_SIZE) + (Vector2i.DOWN * (ROOM_SIZE/2 + 32))
			door.rotation_degrees = 180
			pass
		if room_def.left_door:
			var door : Door = door_prefab.instantiate()
			door_container.add_child(door)
			door.global_position = (pos * ROOM_SIZE) + (Vector2i.LEFT * (ROOM_SIZE/2 + 32))
			door.rotation_degrees = 270
			pass
		pass
	
	pass

func end() -> void:
	enemy_container.queue_free()
	player.queue_free()
	
	pass
