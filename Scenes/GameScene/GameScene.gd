extends Node

var death_screen_packed = preload("res://Scenes/DeathScreen/DeathScreen.tscn")

func _on_MoonWorld_player_camera_x_rotated(value):
	$HelmetViewport/Viewport/Helmet.rotate_camera_x(value)
	$MeteorsViewport/Viewport/MoonMiniature.rotate_camera_x(value)

func _on_MoonWorld_player_camera_y_rotated(value):
	$HelmetViewport/Viewport/Helmet.rotate_camera_y(value)

func _on_MoonWorld_player_camera_y_reset(duration):
	$HelmetViewport/Viewport/Helmet.reset_camera(duration)

func _on_MoonWorld_player_left_foot_grounded(state):
	$HelmetViewport/Viewport/Helmet.toggle_left_light(state)

func _on_MoonWorld_player_right_foot_grounded(state):
	$HelmetViewport/Viewport/Helmet.toggle_right_light(state)

func _on_MoonWorld_player_y_rotated(value):
	$MeteorsViewport/Viewport/MoonMiniature.rotate_camera_y(value)

func _on_MoonWorld_human_died(reason):
	InGameMenuController.open_menu(death_screen_packed, false)
	if InGameMenuController.current_menu.has_method("set_reason"):
		InGameMenuController.current_menu.set_reason(reason)
