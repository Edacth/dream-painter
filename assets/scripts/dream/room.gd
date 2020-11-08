extends Node
class_name Room

class DoorCloseMethod:
	var door: String
	var positions: PoolVector2Array
	var ids: PoolIntArray
	
	func _init(_door: String, _positions: PoolVector2Array, _ids: PoolIntArray):
		door = _door
		positions = _positions
		ids = _ids

var room_name: String
var flags: PoolStringArray
var scene_path: String
var door_close_methods: Array

func _ready():
	pass

func _init(_room_name: String, _flags: PoolStringArray, _scene_path: String, _door_close_methods: Array = []):
	room_name = _room_name
	flags = _flags
	scene_path = _scene_path
	door_close_methods = _door_close_methods
