extends Node2D



func _ready():
	$Generator.importer = $Importer
	$Generator.room_library = $RoomLibrary
	

func generate_world():
	#$Importer.import_scene("res://assets/scenes/dream_scenes/temple.tscn", Vector2(0, 0), false)
	#$Importer.import_scene("res://assets/scenes/dream_scenes/cave.tscn", Vector2(0, -26), false)
	$Generator.on_values_assigned()
