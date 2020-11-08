extends Node
class_name RoomLibrary

var rooms = []

func _ready() -> void:
	read_rooms()

func read_rooms() -> void:
	var door_close_method = Room.DoorCloseMethod.new("left", [Vector2(0, 6)], [0])
	var new_room: Room = Room.new("udlr", ["up_door", "down_door", "left_door", "right_door"], "res://assets/scenes/dream_scenes/test_rooms/udlr_room.tscn",
		[door_close_method])
	rooms.append(new_room)

# Decided this approach wasn't a good idea. May rewrite if I do file reading
#func read_room() -> Room:
#	var scene: PackedScene = load("res://assets/scenes/dream_scenes/test_rooms/udlr_room.tscn")
#	var new_room
#	var instance = scene.instance()
#	print(instance.room_name)
#	return new_room

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
