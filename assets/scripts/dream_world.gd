extends Node2D

signal generation_finished

func _ready():
	pass

func generate_world():
	$Importer.import_scene("res://assets/scenes/dream_scenes/temple.tscn", Vector2(0, 0), false)
	$Importer.import_scene("res://assets/scenes/dream_scenes/cave.tscn", Vector2(0, -26), false)
	emit_signal("generation_finished")
