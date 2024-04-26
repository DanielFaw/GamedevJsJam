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
	
	if !is_filled(Vector2i.UP):
		generated_map[Vector2i.UP] = spawn_room
	if !is_filled(Vector2i.RIGHT):
		generated_map[Vector2i.RIGHT] = spawn_room
	if !is_filled(Vector2i.DOWN):
		generated_map[Vector2i.DOWN] = spawn_room
	if !is_filled(Vector2i.LEFT):
		generated_map[Vector2i.LEFT] = spawn_room
	
	
	
	
	#Apply types by room
	for pos : Vector2i in generated_map.keys():
		if pos == Vector2i.ZERO:
			continue
		var top_neighbor := is_filled(pos + Vector2i.UP)
		var bottom_neighbor := is_filled(pos + Vector2i.DOWN)
		var left_neighbor := is_filled(pos + Vector2i.LEFT)
		var right_neighbor := is_filled(pos + Vector2i.RIGHT)
		
		#Caps
		if top_neighbor && !bottom_neighbor && !left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(is_top_cap).pick_random()
		elif !top_neighbor && bottom_neighbor && !left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(is_bottom_cap).pick_random()
		elif !top_neighbor && !bottom_neighbor && left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(is_left_cap).pick_random()
		elif !top_neighbor && !bottom_neighbor && !left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(is_right_cap).pick_random()
		#Main Entry
		elif top_neighbor && bottom_neighbor && left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(is_big).pick_random()
		#Hallways
		elif top_neighbor && bottom_neighbor && !left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(tb_hallway).pick_random()
		elif !top_neighbor && !bottom_neighbor && left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(lr_hallway).pick_random()
		
		#L-rooms
		elif top_neighbor && !bottom_neighbor && left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(tl_l).pick_random()
		elif !top_neighbor && bottom_neighbor && left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(lb_l).pick_random()
		elif !top_neighbor && bottom_neighbor && !left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(rb_l).pick_random()
		elif top_neighbor && !bottom_neighbor && !left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(tr_l).pick_random()
		
		#T-rooms
		elif top_neighbor && bottom_neighbor && left_neighbor && !right_neighbor:
			generated_map[pos] = all_rooms.filter(t_no_right).pick_random()
		elif top_neighbor && !bottom_neighbor && left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(t_no_bottom).pick_random()
		elif top_neighbor && bottom_neighbor && !left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(t_no_left).pick_random()
		elif !top_neighbor && bottom_neighbor && left_neighbor && right_neighbor:
			generated_map[pos] = all_rooms.filter(t_no_top).pick_random()
		else:
			print("ERROR GENERATING ROOM!")
		
		
		pass

	pass

func t_no_top(r : RoomDefinition) -> bool:
	return r.left_door && r.right_door && !r.top_door && r.bottom_door
func t_no_right(r : RoomDefinition) -> bool:
	return r.left_door && !r.right_door && r.top_door && r.bottom_door
func t_no_bottom(r : RoomDefinition) -> bool:
	return r.left_door && r.right_door && r.top_door && !r.bottom_door
func t_no_left(r : RoomDefinition) -> bool:
	return !r.left_door && r.right_door && r.top_door && r.bottom_door

func tr_l(r : RoomDefinition) -> bool:
	return !r.left_door && r.right_door && r.top_door && !r.bottom_door
func rb_l(r : RoomDefinition) -> bool:
	return !r.left_door && r.right_door && !r.top_door && r.bottom_door
func lb_l(r : RoomDefinition) -> bool:
	return r.left_door && !r.right_door && !r.top_door && r.bottom_door
func tl_l(r : RoomDefinition) -> bool:
	return r.left_door && !r.right_door && r.top_door && !r.bottom_door

func lr_hallway(r : RoomDefinition) -> bool:
	return r.left_door && r.right_door && !r.top_door && !r.bottom_door

func tb_hallway(r : RoomDefinition) -> bool:
	return !r.left_door && !r.right_door && r.top_door && r.bottom_door

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

func is_big(r : RoomDefinition) -> bool:
	return r.left_door && r.right_door && r.top_door && r.bottom_door






