extends Node2D

enum {STILL, MOVING}

var move_increment = 8
var move_vec = Dir2Vec.Dir.UP
var move_speed = 7
var move_progress
var start_point
var end_point
onready var terrain_map : TileMap
onready var kinematicBody: KinematicBody2D = get_node("KinematicBody2D")
var nearest_interactable_object: Interactable_Object = null
onready var interact_distance = 13
var move_state = STILL

func _ready():
	pass # Replace with function body. 
	
func _unhandled_input(event):
	if event.is_action_pressed("test"):
		attempt_interact()


func try_move(direction):
	move_vec = Dir2Vec.dic[direction] * move_increment
	start_point = position
	end_point = position + move_vec
	var test_move = kinematicBody.test_move(transform, move_vec, false)
	if test_move == false:
		start_move()


func start_move():
	move_state = MOVING
	move_progress = 0
	#print("start move")
	

func end_move():
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "interactable_object", "reset_highlight")
	nearest_interactable_object = get_interact_objects_in_range()
	#if is_instance_valid(nearest_interactable_object): nearest_interactable_object.highlight()
	#print("end move")


func _physics_process(delta):
	if Input.is_action_pressed("left") && move_state == STILL:
		try_move(Dir2Vec.Dir.LEFT)
	if Input.is_action_pressed("right") && move_state == STILL:
		try_move(Dir2Vec.Dir.RIGHT)
	if Input.is_action_pressed("up") && move_state == STILL:
		try_move(Dir2Vec.Dir.UP)
	if Input.is_action_pressed("down") && move_state == STILL:
		try_move(Dir2Vec.Dir.DOWN)

	if move_state == MOVING:
		move_progress += move_toward(0, 1, delta * move_speed)
		move_progress = clamp(move_progress, 0, 1)
		position.y = lerp(start_point.y, end_point.y, move_progress)
		position.x = lerp(start_point.x, end_point.x, move_progress)
		if is_equal_approx(move_progress, 1):
			move_state = STILL
			end_move()

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
	
func get_interact_objects_in_range():
	var interactable_objects = get_tree().get_nodes_in_group("interactable_object")
	for obj in interactable_objects:
		if obj.within_range_of_player == true:
			return obj
	return null
