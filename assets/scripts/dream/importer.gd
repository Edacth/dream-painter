extends Node2D
class_name Importer

var main_terrain_tilemap: TileMap
var main_background_tilemap: TileMap

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
			$"ImportRoot/TerrainTilemap".set_cell(mod.positions[i].x, mod.positions[i].y, mod.ids[i], false, false, false, mod.autotile_coords[i])
	merge_tilemap(main_terrain_tilemap, $"ImportRoot/TerrainTilemap", instance_offset, import_position, import_air)
	var test = get_node("ImportRoot").get_children()
	if get_node_or_null("ImportRoot/BackgroundTilemap") != null:
		merge_tilemap(main_background_tilemap, $"ImportRoot/BackgroundTilemap", instance_offset, import_position, import_air)
	$"ImportRoot/EntryPoint".queue_free()
	$"ImportRoot".remove_child($"ImportRoot/EntryPoint")
	# Copy remaining child nodes. These are objects of the room.
	for obj in instance_root.get_children():
		var old_parent = obj.get_parent()
		var new_parent = self.get_parent()
		old_parent.remove_child(obj)
		new_parent.add_child(obj)
		obj.position -= instance_offset - (import_position * 8)
	instance_root.queue_free()
	self.remove_child(instance_root)


func merge_tilemap(to_tilemap: TileMap, from_tilemap: TileMap, offset, import_position, import_air):
	var used_cells = from_tilemap.get_used_cells()
	var from_tilemap_size = Vector2(0, 0)
	for cell in used_cells:
		if cell.x > from_tilemap_size.x:
			from_tilemap_size.x = cell.x
		if cell.y > from_tilemap_size.y:
			from_tilemap_size.y = cell.y
	var tile_offset = Vector2(offset.x /8, offset.y /8)
	for i in range(from_tilemap_size.x+1):
		for j in range(from_tilemap_size.y+1):
			var cell = from_tilemap.get_cell(i, j)
			var autotile_coord = from_tilemap.get_cell_autotile_coord(i, j)
			var is_cell_x_flipped = from_tilemap.is_cell_x_flipped(i, j)
			var is_cell_y_flipped = from_tilemap.is_cell_y_flipped(i, j)
			var is_cell_transposed = from_tilemap.is_cell_transposed(i, j)
			if import_air == false and cell == -1:
				continue
			to_tilemap.set_cell(i - tile_offset.x + import_position.x, j - tile_offset.y + import_position.y, cell,
				is_cell_x_flipped, is_cell_y_flipped, is_cell_transposed, autotile_coord)
	from_tilemap.queue_free()
	$"ImportRoot".remove_child(from_tilemap)
