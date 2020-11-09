extends Node2D
class_name Importer

func import_scene(path, import_position, import_air, modifications = []):
	var scene_to_import = load(path)
	var scene_instance = scene_to_import.instance()
	# Add scene as child of importer in order to have its nodes and cells copied
	self.add_child(scene_instance, true)
	var instance_root = $"ImportRoot"
	var instance_offset = ($"ImportRoot/EntryPoint").position
	instance_root.position -= import_position + instance_offset
	# Make specified modifications
	for mod in modifications:
		for i in mod.positions.size():
			$"ImportRoot/TerrainTilemap".set_cellv(mod.positions[i], mod.ids[i])
	merge_tilemap($"ImportRoot/TerrainTilemap", instance_offset, import_position, import_air)
	# Copy remaining child nodes. These are objects of the room.
	for obj in instance_root.get_children():
		var old_parent = obj.get_parent()
		var new_parent = self.get_parent()
		old_parent.remove_child(obj)
		new_parent.add_child(obj)
		obj.position -= instance_offset - (import_position * 8)
	instance_root.queue_free()
	self.remove_child(instance_root)

func merge_tilemap(new_tilemap: TileMap, offset, import_position, import_air):
	var used_cells = new_tilemap.get_used_cells()
	var new_tilemap_size = Vector2(0, 0)
	for cell in used_cells:
		if cell.x > new_tilemap_size.x:
			new_tilemap_size.x = cell.x
		if cell.y > new_tilemap_size.y:
			new_tilemap_size.y = cell.y
	#print(str(new_tilemap_size))
	var main_tilemap: TileMap = get_parent().get_node("TerrainTileMap")
	var tile_offset = Vector2(offset.x /8, offset.y /8)
	for i in range(new_tilemap_size.x+1):
		for j in range(new_tilemap_size.y+1):
			var cell = new_tilemap.get_cell(i, j)
			if import_air == false and cell == -1:
				continue
			main_tilemap.set_cell(i - tile_offset.x + import_position.x, j - tile_offset.y + import_position.y, cell, false)
	$"ImportRoot/TerrainTilemap".queue_free()
	$"ImportRoot".remove_child($"ImportRoot/TerrainTilemap")
	$"ImportRoot/EntryPoint".queue_free()
	$"ImportRoot".remove_child($"ImportRoot/EntryPoint")
