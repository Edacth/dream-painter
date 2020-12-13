extends Node2D

func _ready():
	$Generator.importer = $Importer
	$Generator.room_library = $RoomLibrary
	$Importer.main_terrain_tilemap = $TerrainTilemap
	$Importer.main_background_tilemap = $BackgroundTilemap
	$Importer.objects_node = $Objects
	connect_dialog_manager()
	$DialogManager.read_conversations()
	

func generate_world():
	#$Importer.import_scene("res://assets/scenes/dream_scenes/temple.tscn", Vector2(0, 0), false)
	#$Importer.import_scene("res://assets/scenes/dream_scenes/cave.tscn", Vector2(0, -26), false)
	$Generator.on_values_assigned()

func connect_dialog_manager():
	$DialogManager.dream_gui = $DreamGUI
	$DialogManager.dialog_box = $DreamGUI/DialogBox
	$DialogManager.dialog_label = $DreamGUI/DialogBox/Panel/Panel/MainLabel
	$DialogManager.choice_container = $DreamGUI/DialogBox/Panel/Panel/ChoiceContainer
	$DialogManager.set_player_input_blockage_func = funcref(self, "set_player_input_blockage")

func request_convo(convo_name: String):
	$DialogManager.request_convo(convo_name)


func set_player_input_blockage(value: bool):
	$Player.block_input = value
