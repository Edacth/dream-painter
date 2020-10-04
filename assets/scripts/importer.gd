extends Node2D

signal importing_finished

func _ready():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("test1"):
		import_scene("res://assets/scenes/dream_scenes/temple.tscn", Vector2(0, 0), false)
		#import_scene("res://assets/scenes/temple.tscn", Vector2(0, -12), false)
		#import_scene("res://assets/scenes/temple.tscn", Vector2(10, -12), false)
		emit_signal("importing_finished")

func import_scene(path, import_position, import_air):
	var scene_to_import = load(path)
	var scene_instance = scene_to_import.instance()
	self.add_child(scene_instance, true)
	var instance_root = $"ImportRoot"
	var instance_offset = ($"ImportRoot/EntryPoint").position
	instance_root.position -=  import_position + instance_offset
	merge_tilemap($"ImportRoot/TerrainTilemap", instance_offset, import_position, import_air)
	for obj in instance_root.get_children():
		var old_parent = obj.get_parent()
		var new_parent = self.get_parent()
		old_parent.remove_child(obj)
		#new_parent.call_deferred("add_child", obj)
		new_parent.add_child(obj)
		obj.position -= instance_offset
	instance_root.queue_free()
	self.remove_child(instance_root)

func merge_tilemap(new_tilemap: TileMap, offset, import_position, import_air):
	var main_tilemap: TileMap = get_parent().get_node("TerrainTileMap")
	var tile_offset = Vector2(offset.x /8, offset.y /8)
	for i in range(20):
		for j in range(0,-20,-1):
			var cell = new_tilemap.get_cell(i, j)
			if import_air == false and cell == -1:
				continue
			main_tilemap.set_cell(i - tile_offset.x + import_position.x, j - tile_offset.y + import_position.y, cell, false)
	$"ImportRoot/TerrainTilemap".queue_free()
	$"ImportRoot".remove_child($"ImportRoot/TerrainTilemap")
	$"ImportRoot/EntryPoint".queue_free()
	$"ImportRoot".remove_child($"ImportRoot/EntryPoint")
