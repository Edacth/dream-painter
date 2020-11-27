extends Node
class_name RoomLibrary

var rooms = []

func _ready() -> void:
	read_rooms()

func read_rooms() -> void:
	var file = File.new()
	
	file.open("res://rooms.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	var result = json.result
	# Make sure json is okay
	if json.error == OK && typeof(result) == TYPE_DICTIONARY:
		for r in result["rooms"]:
			# Parse door close methods
			var door_close_methods: Array = []
			for m in r["door_close_methods"]:
				# Positions
				var positions: Array = []
				for position in m["positions"]:
					positions.append(Vector2(position[0], position[1]))
				# Ids
				var ids: Array = []
				var autotile_coords: Array = []
				for id in m["ids"]:
					ids.append(id)
				# Autotile coords
				for coord in m["autotile_coords"]:
					autotile_coords.append(Vector2(coord[0], coord[1]))
				var new_method = Room.DoorCloseMethod.new(m["door"], positions, ids, autotile_coords)
				door_close_methods.append(new_method)
			# Create room and append it
			var new_room: Room = Room.new(r["room_name"], r["flags"], r["scene_path"], door_close_methods)
			rooms.append(new_room)
	

func get_rooms_with_flags(required_flags: PoolStringArray) -> Array:
	var valid_rooms: Array = []
	for room in rooms:
		var success_count: int = 0
		for flag in room.flags:
			for r_flag in required_flags:
				if flag == r_flag:
					success_count += 1
					break
			if success_count >= required_flags.size():
				valid_rooms.append(room)
				break
	return valid_rooms
