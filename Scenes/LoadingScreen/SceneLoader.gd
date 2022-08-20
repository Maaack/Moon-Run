extends Node


var loading_screen = preload("res://Scenes/LoadingScreen/LoadingScreen.tscn")
var scene_to_load : String

func load_scene(path : String) -> void:
	get_tree().paused = false
	scene_to_load = path
	get_tree().change_scene_to(loading_screen)
