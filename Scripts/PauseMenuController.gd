extends Node

var pause_menu_packed = preload("res://Scenes/PauseMenu/PauseMenu.tscn")
var current_menu : CanvasLayer
var old_mouse_mode : int
var paused : bool = false setget set_paused


func set_paused(value : bool) -> void:
	if paused == value:
		return
	
	paused = value
	
	if paused ==  true:
		old_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		current_menu = pause_menu_packed.instance()
		get_tree().current_scene.add_child(current_menu)
		get_tree().paused = true
	elif paused == false:
		current_menu.queue_free()
		Input.set_mouse_mode(old_mouse_mode)
		get_tree().paused = false
	
