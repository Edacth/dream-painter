extends Node2D
var importer : Importer
var room_library: RoomLibrary

const ROOM_SIZE: int = 14 # They are square to int
var level_layout: Array # Array of rooms

class LayoutRoom:
	var pos: Vector2
	var flags: Array = []
	
	func _init(_pos: Vector2):
		pos = _pos

	func has_flag(flag_name: String) -> bool:
		for flag in flags:
			if flag == flag_name:
				return true
		return false


func on_values_assigned():
	randomize()
	level_layout = run_random_walk(Vector2(0,0), 3)
	#layout.append_array(run_random_walk(Vector2(0,0), 8))
	for room in level_layout:
		room.flags = calc_door_flags(room)
	generate_visualization(level_layout)

func run_random_walk(start_point: Vector2, length: int) -> Array:
	var current_pos: Vector2 = start_point
	var path = []
	path.append(LayoutRoom.new(current_pos))
	for _i in range(0, length):
		current_pos = current_pos + Dir2Vec.dic[randi() % 4]
		#print(current_pos)
		var found: bool = false
		for room in path:
			if room.pos == current_pos:
				found = true
				break
		if !found:
			path.append(LayoutRoom.new(current_pos))
	return path

func generate_visualization(layout):
	for room in layout:
		# TODO: Choose from the valid rooms randomly
		# TODO: Properly apply the modifications based on the flags
		var valid_rooms: Array = room_library.get_rooms_with_flags(room.flags)
		var modifications = []
		# Up door modification
		if !(room.has_flag("up_door")):
			for mod in valid_rooms[0].door_close_methods:
				if mod.door == "up":
					modifications.append(mod)
					break
		# Down door modification
		if !(room.has_flag("down_door")):
			for mod in valid_rooms[0].door_close_methods:
				if mod.door == "down":
					modifications.append(mod)
					break
		# Left door modification
		if !(room.has_flag("left_door")):
			for mod in valid_rooms[0].door_close_methods:
				if mod.door == "left":
					modifications.append(mod)
					break
		# Right door modification
		if !(room.has_flag("right_door")):
			for mod in valid_rooms[0].door_close_methods:
				if mod.door == "right":
					modifications.append(mod)
					break
		
		importer.import_scene(valid_rooms[0].scene_path, room.pos * ROOM_SIZE, false, modifications)

#	for room in layout:
#		if room.has_flag("up_door"):
#			importer.import_scene("res://assets/scenes/dream_scenes/test_rooms/u_room.tscn", room.pos * ROOM_SIZE, false)
#		elif room.has_flag("down_door"):
#			importer.import_scene("res://assets/scenes/dream_scenes/test_rooms/d_room.tscn", room.pos * ROOM_SIZE, false)
#		else:
#			importer.import_scene("res://assets/scenes/dream_scenes/test_rooms/_room.tscn", room.pos * ROOM_SIZE, false)

func calc_door_flags(room: LayoutRoom) -> Array:
	var flags = []
	var adjactent: Vector2 = room.pos + Dir2Vec.dic[Dir2Vec.Dir.UP]
	
	# up_door flag
	for i in level_layout:
		if i.pos == adjactent:
			flags.append("up_door")
	
	# down_door flag
	adjactent = room.pos + Dir2Vec.dic[Dir2Vec.Dir.DOWN]
	for i in level_layout:
		if i.pos == adjactent:
			flags.append("down_door")
	
	# left_door flag
	adjactent = room.pos + Dir2Vec.dic[Dir2Vec.Dir.LEFT]
	for i in level_layout:
		if i.pos == adjactent:
			flags.append("left_door")
			
	# left_door flag
	adjactent = room.pos + Dir2Vec.dic[Dir2Vec.Dir.RIGHT]
	for i in level_layout:
		if i.pos == adjactent:
			flags.append("right_door")
	return flags
	
func check_duplicates(a):
	var is_dupe = false
	var found_dupe = false 

	for i in range(a.size()):
		if is_dupe == true:
			break
		for j in range(a.size()):
			if a[j] == a[i] && i != j:
				is_dupe = true
				found_dupe = true
				print("duplicate")
				break
