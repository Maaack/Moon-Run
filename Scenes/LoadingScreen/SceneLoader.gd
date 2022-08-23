extends Node


var loading_screen = preload("res://Scenes/LoadingScreen/LoadingScreen.tscn")
var scene_to_load : String

func load_scene(path : String) -> void:
	var master_idx = AudioServer.get_bus_index("Master")
	var master_volume = AudioServer.get_bus_volume_db(master_idx)
	AudioServer.set_bus_volume_db(master_idx, -80)
	get_tree().paused = false
	scene_to_load = path
	var err = get_tree().change_scene_to(loading_screen)
	if err:
		print("failed to load loading screen: %d" % err)
		get_tree().quit()
	AudioServer.set_bus_volume_db(master_idx, master_volume)
