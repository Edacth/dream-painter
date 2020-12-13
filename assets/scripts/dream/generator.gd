extends Node2D

signal generation_finished

var importer : Importer
var room_library: RoomLibrary

const ROOM_SIZE: int = 14 # They are square to int
var level_layout: Array # Array of rooms

class LayoutRoom:
	var pos: Vector2
	var flags: PoolStringArray = []
	
	func _init(_pos: Vector2):
		pos = _pos

	func has_flag(flag_name: String) -> bool:
		for flag in flags:
			if flag == flag_name:
				return true
		return false


func on_values_assigned():
	importer.clear_layout()
	randomize()
	generate_layout()
	
	for room in level_layout:
		var flags: PoolStringArray = []
		flags.append_array(calc_door_flags(room))
		flags.append_array(calc_other_flags(room))
		room.flags = flags
	generate_visualization(level_layout)
	emit_signal("generation_finished")


func generate_layout() -> void:
	for _i in range(0, 2):
		var path = run_random_walk(Vector2(0,0), 3)
		# Avoid adding any rooms in the same position
		for p_room in path:
			var found: bool = false
			for l_room in level_layout:
				if p_room.pos == l_room.pos:
					found = true
					break
			if !found:
				level_layout.append(p_room)


func run_random_walk(start_point: Vector2, length: int) -> Array:
	var current_pos: Vector2 = start_point
	var path = []
	path.append(LayoutRoom.new(current_pos))
	for _i in range(0, length):
		current_pos = current_pos + Dir2Vec.dic[randi() % 4]
		path.append(LayoutRoom.new(current_pos))
	return path


func generate_visualization(layout) -> void:
	for room in layout:
		var chosen_room_type = choose_room_type(room)
		var modifications = []
		# Up door modification
		if !(room.has_flag("up_door")):
			for mod in chosen_room_type.door_close_methods:
				if mod.door == "up":
					modifications.append(mod)
					break
		# Down door modification
		if !(room.has_flag("down_door")):
			for mod in chosen_room_type.door_close_methods:
				if mod.door == "down":
					modifications.append(mod)
					break
		# Left door modification
		if !(room.has_flag("left_door")):
			for mod in chosen_room_type.door_close_methods:
				if mod.door == "left":
					modifications.append(mod)
					break
		# Right door modification
		if !(room.has_flag("right_door")):
			for mod in chosen_room_type.door_close_methods:
				if mod.door == "right":
					modifications.append(mod)
					break
		
		importer.import_scene(chosen_room_type.scene_path, room.pos * ROOM_SIZE, false, modifications)


## Calculate what door flags a room should have
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


func calc_other_flags(room: LayoutRoom) -> PoolStringArray:
	var flags : PoolStringArray = []
	
	# start_room flag
	if room.pos == Vector2(0, 0):
		flags.append("start_room")
	else:
		flags.append("normal_room")
	return flags


# Checks for duplicates in an array. I guess it's not used
func check_duplicates(a):
	var is_dupe = false

	for i in range(a.size()):
		if is_dupe == true:
			break
		for j in range(a.size()):
			if a[j] == a[i] && i != j:
				is_dupe = true
				print("duplicate")
				break


func choose_room_type(room: LayoutRoom) -> Room:
	# TODO: Choose from the valid rooms randomly
	var valid_rooms: Array = room_library.get_rooms_with_flags(room.flags)
	var rand = randi() % valid_rooms.size()
	return valid_rooms[rand]
