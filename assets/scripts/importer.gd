extends Node2D

func _ready():
	pass
	#import_scene("res://assets/scenes/temple.tscn", Vector2(0, 0), false)
	#import_scene("res://assets/scenes/temple.tscn", Vector2(0, -12), false)
	#import_scene("res://assets/scenes/temple.tscn", Vector2(10, -12), false)
	

func import_scene(path, import_position, import_air):
	var scene_to_import = load(path)
	var grabbed_instance = scene_to_import.instance()
	self.add_child(grabbed_instance, true)
	var instance_root = $"ImportRoot"
	var instance_offset = ($"ImportRoot/EntryPoint").position
	instance_root.position -=  import_position + instance_offset
	merge_tilemap($"ImportRoot/TerrainTilemap", instance_offset, import_position, import_air)

func merge_tilemap(new_tilemap: TileMap, offset, import_position, import_air):
	var main_tilemap: TileMap = get_parent().get_node("TileMap")
	var tile_offset = Vector2(offset.x /8, offset.y /8)
	for i in range(20):
		for j in range(0,-20,-1):
			var cell = new_tilemap.get_cell(i, j)
			if import_air == false and cell == -1:
				continue
			main_tilemap.set_cell(i - tile_offset.x + import_position.x, j - tile_offset.y + import_position.y, cell, false)
	print(get_child(0).name)
	get_child(0).queue_free()
	remove_child(get_child(0))

