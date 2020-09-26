extends Node2D

var move_increment = 8
onready var terrain_map : TileMap = get_node("/root/Root/TerrainTileMap")
onready var kinematicBody: KinematicBody2D = get_node("KinematicBody2D")
var nearest_interactable_object: Interactable_Object = null
onready var interact_distance = 9

func _ready():
	pass # Replace with function body. 
	
func _unhandled_input(event):
	if event.is_action_pressed("left"):
		move(Dir2Vec.Dir.LEFT)
	if event.is_action_pressed("right"):
		move(Dir2Vec.Dir.RIGHT)
	if event.is_action_pressed("up"):
		move(Dir2Vec.Dir.UP)
	if event.is_action_pressed("down"):
		move(Dir2Vec.Dir.DOWN)
	if event.is_action_pressed("test"):
		attempt_interact()


func move(direction):
	var move_vec = Dir2Vec.dic[direction] * move_increment
	var test_move = kinematicBody.test_move(transform, move_vec, false)
	if test_move == false:
		position += move_vec
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "interactable_object", "reset_highlight")
	nearest_interactable_object = get_nearest_interactable_object()
	if is_instance_valid(nearest_interactable_object): nearest_interactable_object.highlight()
	

func printTile():
	var map_coords = terrain_map.world_to_map(position)
	print(position, " ", map_coords)
	print(terrain_map.get_cellv(map_coords))
	
func attempt_interact():
	if is_instance_valid(nearest_interactable_object): nearest_interactable_object.interact()
		
func get_nearest_interactable_object():
	var interactable_objects = get_tree().get_nodes_in_group("interactable_object")
	var shortest_distance = 9223372036854775807
	var nearest_object = null
	for obj in interactable_objects:
		var distance_to_object = position.distance_to(obj.position)
		if distance_to_object < shortest_distance and distance_to_object <= interact_distance:
			shortest_distance = distance_to_object
			nearest_object = obj
	return nearest_object
	
