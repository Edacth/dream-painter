extends Node

enum CellType {
	EMPTY = -1
	P_NEUTRAL,
	P_DAMAGE,
	P_BLOCK,
	E_DAMAGE
}

var player_shapes = []
var enemy_shapes = []


func _ready() -> void:
	read_player_shapes()
	read_enemy_shapes()


func read_player_shapes() -> void:
	var icon_path_dir = "res://assets/textures/shape_icons/"
	var preview_path_dir = "res://assets/textures/shape_previews/"
	var file = File.new()
	
	file.open("res://player_shapes.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	var result = json.result
	# Make sure json is okay
	if json.error == OK && typeof(result) == TYPE_DICTIONARY:
		# parse shapes
		var shapes = []
		for s in result["shapes"]:
			var cells: Array = []
			for c in s["cells"]:
				#Position
				var position = Vector2(c["pos"][0], c["pos"][1])
				var type = c["type"]
				cells.append(Cell.new(position, type))
			
			var icon_path = icon_path_dir + s["name"] + ".png"
			if !file.file_exists(icon_path):
				icon_path = icon_path_dir + "blank.png"
			var preview_path = preview_path_dir + s["name"] + "_preview.png"
			if !file.file_exists(preview_path):
				preview_path = preview_path_dir + "blank_preview.png"
			var new_shape = CellShape.new(s["name"], s["display_name"], cells, icon_path, preview_path)
			player_shapes.append(new_shape)


func read_enemy_shapes() -> void:
	# test
	var cells = [Cell.new(Vector2(0, 0), CellType.E_DAMAGE)]
	var shape = CellShape.new("test", "", cells, "", "")
	enemy_shapes.append(shape)


func get_player_shape(name: String) -> CellShape:
	for shape in player_shapes:
		if (shape.name == name):
			return shape
	return player_shapes[0] # return blank shape


func get_enemy_shape(name: String) -> CellShape:
	for shape in enemy_shapes:
		if (shape.name == name):
			return shape
	return null


class CellShape:
	var name = ""
	var display_name = ""
	var cells = []
	var icon_path: String
	var preview_path: String
	
	
	func _init(_name: String, _display_name: String, _cells: Array, _icon_path: String, _preview_path: String):
		name = _name
		display_name = _display_name
		cells = _cells
		icon_path = _icon_path
		preview_path = _preview_path


class Cell:
	var position
	var type = 0
	
	
	func _init(_position: Vector2, _type: int):
		position = _position
		type = _type
