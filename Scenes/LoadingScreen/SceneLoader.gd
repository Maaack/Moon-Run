extends Node


var loading_screen = preload("res://Scenes/LoadingScreen/LoadingScreen.tscn")
var scene_to_load : String

func load_scene(path : String) -> void:
	var master_idx = AudioServer.get_bus_index("Master")
	var master_volume = AudioServer.get_bus_volume_db(master_idx)
	AudioServer.set_bus_volume_db(master_idx, -80)
	get_tree().paused = false
	scene_to_load = path
	get_tree().change_scene_to(loading_screen)
	AudioServer.set_bus_volume_db(master_idx, master_volume)
