extends Node2D
class_name MainGame

const ROOM_SIZE := 256 * 20


var door_prefab : PackedScene = preload("res://Prefabs/door.tscn")


@export var room_container : Node2D
@export var door_container : Node2D


var room_data : Array[RoomDefinition]
var generator : RoomGenerator

var layout := {}

func _init() -> void:
	var dir := DirAccess.open("res://Rooms")
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
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
		
		var room := room_def.room.instantiate()
		room_container.add_child(room)
		room.global_position = pos * ROOM_SIZE
		
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
