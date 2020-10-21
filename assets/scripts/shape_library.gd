extends Node

var cell_shapes: = []

func _ready() -> void:
	read_shapes()
	print(cell_shapes)

func read_shapes() -> void:
	# Test
	var cells = [Cell.new(Vector2(0, 0), 0)]
	var shape = CellShape.new("test", cells)
	cell_shapes.append(shape)
	
	# Tall
	cells = [
		Cell.new(Vector2(0, 0), 0),
		Cell.new(Vector2(0, -1), 0)]
	shape = CellShape.new("tall", cells)
	cell_shapes.append(shape)
	
	# Sword
	cells = [
		Cell.new(Vector2(0, 0), 2),
		Cell.new(Vector2(0, -1), 0),
		Cell.new(Vector2(0, -2), 0)]
	shape = CellShape.new("sword", cells)
	cell_shapes.append(shape)
	
	# Shield
	cells = [
		Cell.new(Vector2(0, 0), 2),
		Cell.new(Vector2(0, -1), 1),
		Cell.new(Vector2(1, 0), 1),
		Cell.new(Vector2(1, -1), 1)]
	shape = CellShape.new("shield", cells)
	cell_shapes.append(shape)
	
func get_shape(name: String) -> CellShape:
	for shape in cell_shapes:
		if (shape.name == name):
			return shape
	return null
	
class CellShape:
	var name = ""
	var cells = []
	
	func _init(_name: String, _cells: Array):
		name = _name
		cells = _cells
	
class Cell:
	var position
	var type = 0
	
	func _init(_position: Vector2, _type: int):
		position = _position
		type = _type
