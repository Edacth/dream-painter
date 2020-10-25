extends Node

enum CellType {
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
	# test
	var cells = [Cell.new(Vector2(0, 0), CellType.P_DAMAGE)]
	var shape = CellShape.new("test", cells)
	player_shapes.append(shape)
	
	# tall
	cells = [
		Cell.new(Vector2(0, 0), CellType.P_DAMAGE),
		Cell.new(Vector2(0, -1), CellType.P_DAMAGE)]
	shape = CellShape.new("tall", cells)
	player_shapes.append(shape)
	
	# sword
	cells = [
		Cell.new(Vector2(0, 0), CellType.P_NEUTRAL),
		Cell.new(Vector2(0, -1), CellType.P_DAMAGE),
		Cell.new(Vector2(0, -2), CellType.P_DAMAGE)]
	shape = CellShape.new("sword", cells)
	player_shapes.append(shape)
	
	# shield
	cells = [
		Cell.new(Vector2(0, 0), CellType.P_NEUTRAL),
		Cell.new(Vector2(0, -1), CellType.P_BLOCK),
		Cell.new(Vector2(1, 0), CellType.P_BLOCK),
		Cell.new(Vector2(1, -1), CellType.P_BLOCK)]
	shape = CellShape.new("shield", cells)
	player_shapes.append(shape)
	
	# down_sword
	cells = [
		Cell.new(Vector2(0, 0), CellType.P_NEUTRAL),
		Cell.new(Vector2(0, 1), CellType.P_DAMAGE),
		Cell.new(Vector2(0, 2), CellType.P_DAMAGE)]
	shape = CellShape.new("down_sword", cells)
	player_shapes.append(shape)

func read_enemy_shapes() -> void:
	# test
	var cells = [Cell.new(Vector2(0, 0), CellType.E_DAMAGE)]
	var shape = CellShape.new("test", cells)
	enemy_shapes.append(shape)
	
func get_player_shape(name: String) -> CellShape:
	for shape in player_shapes:
		if (shape.name == name):
			return shape
	return null
	
func get_enemy_shape(name: String) -> CellShape:
	for shape in enemy_shapes:
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
