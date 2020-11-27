extends Node2D

func _ready():
	$Generator.importer = $Importer
	$Generator.room_library = $RoomLibrary
	$Importer.main_terrain_tilemap = $TerrainTilemap
	$Importer.main_background_tilemap = $BackgroundTilemap
	connect_dialog_manager()
	$DialogManager.read_conversations()
	

func generate_world():
	#$Importer.import_scene("res://assets/scenes/dream_scenes/temple.tscn", Vector2(0, 0), false)
	#$Importer.import_scene("res://assets/scenes/dream_scenes/cave.tscn", Vector2(0, -26), false)
	$Generator.on_values_assigned()

func connect_dialog_manager():
	$DialogManager.dialog_box = $DreamGUI/DialogBox/Panel/Panel/Label
	$DialogManager.test()
