extends Node

var pause_menu_packed = preload("res://Scenes/PauseMenu/PauseMenu.tscn")

var can_pause = true # to prevent from instantly repausing after unpaused from the pause menu by pressing ui_cancel

func _process(_delta):
	# cannot repause before releasing the key once
	if Input.is_action_just_pressed("ui_cancel") and can_pause:
		can_pause = false
		InGameMenuController.open_menu(pause_menu_packed, false)
	else:
		can_pause = true

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
