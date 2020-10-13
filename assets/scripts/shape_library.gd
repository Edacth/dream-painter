extends Node

var cell_shapes: = []

func _ready() -> void:
	read_shapes()
	print(cell_shapes)

func read_shapes() -> void:
	var cells = [Cell.new(Vector2(0, 0), 0)]
	var shape = CellShape.new("Test", cells)
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
	var id = 0
	
	func _init(_position: Vector2, _id: int):
		position = _position
		id = _id
