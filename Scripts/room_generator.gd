class_name RoomGenerator

var all_rooms : Array[RoomDefinition]


#A vector2i:roomdefinition key/value pair
var generated_map := {}

func generate(rms : Array[RoomDefinition], count : int = 10) -> void:
	all_rooms = rms
	
	#var spawn := all_rooms.find()
	var spawn_room : RoomDefinition = all_rooms.filter(is_spawn_room).front()
	var rooms : Array[RoomDefinition] = all_rooms.filter(is_not_spawn_room)
	
	var top_caps : Array[RoomDefinition] = all_rooms.filter(is_top_cap)
	var right_caps : Array[RoomDefinition] = all_rooms.filter(is_right_cap)
	var bottom_caps : Array[RoomDefinition] = all_rooms.filter(is_bottom_cap)
	var left_caps : Array[RoomDefinition] = all_rooms.filter(is_left_cap)
	
	generated_map[Vector2i.ZERO] = spawn_room
	
	#Mark (count) rooms as needing to be filled
	var cursor := Vector2i.ZERO
	var counter := 0
	var rng : int
	
	while counter < count:
		rng = randi_range(0, 4)
		if rng == 0:
			cursor += Vector2i.UP
		elif rng == 1:
			cursor += Vector2i.RIGHT
		elif rng == 2:
			cursor += Vector2i.DOWN
		else:
			cursor += Vector2i.LEFT
		
		if is_filled(cursor):
			cursor = random_cursor()
		else:
			generated_map[cursor] = spawn_room
			counter += 1
		pass
	
	#Apply types by room (need rooms first tho)
	

	
	pass

func is_filled(pos : Vector2i) -> bool:
	return generated_map.keys().has(pos)

func random_cursor() -> Vector2i:
	return generated_map.keys().pick_random()

func is_spawn_room(r : RoomDefinition) -> bool:
	return r.spawn_room

func is_not_spawn_room(r : RoomDefinition) -> bool:
	return !r.spawn_room

func is_left_cap(r : RoomDefinition) -> bool:
	return !r.spawn_room && r.left_door && !r.right_door && !r.top_door && !r.bottom_door

func is_right_cap(r : RoomDefinition) -> bool:
	return !r.spawn_room && !r.left_door && r.right_door && !r.top_door && !r.bottom_door

func is_top_cap(r : RoomDefinition) -> bool:
	return !r.spawn_room && !r.left_door && !r.right_door && r.top_door && !r.bottom_door

func is_bottom_cap(r : RoomDefinition) -> bool:
	return !r.spawn_room && !r.left_door && !r.right_door && !r.top_door && r.bottom_door

