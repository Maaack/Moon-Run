extends Node

var death_screen_packed = preload("res://Scenes/DeathScreen/DeathScreen.tscn")
var success_screen_packed = preload("res://Scenes/SuccessScreen/SuccessScreen.tscn")
var left_foot_down : bool = false
var right_foot_down : bool = false
var rumble_in_open_space = 0.1

func recalculate_rumble():
	var rumble_value : float = rumble_in_open_space
	rumble_value += int(left_foot_down) + int(right_foot_down)
	rumble_value /= 2.0 + rumble_in_open_space
	_set_rumble_linear_2_volume(rumble_value)

func _set_rumble_linear_2_volume(linear : float) -> void:
	var volume_db : float = linear2db(linear)
	$AudioPlayers/LowRumble.volume_db = linear2db(linear)

func _on_MoonWorld_player_camera_x_rotated(value):
	$HelmetViewport/Viewport/Helmet.rotate_camera_x(value)
	$MeteorsViewport/Viewport/MoonMiniature.rotate_camera_x(value)

func _on_MoonWorld_player_camera_y_rotated(value):
	$HelmetViewport/Viewport/Helmet.rotate_camera_y(value)

func _on_MoonWorld_player_camera_y_reset(duration):
	$HelmetViewport/Viewport/Helmet.reset_camera(duration)

func _on_MoonWorld_player_left_foot_grounded(state):
	$HelmetViewport/Viewport/Helmet.toggle_left_light(state)
	left_foot_down = state
	recalculate_rumble()

func _on_MoonWorld_player_right_foot_grounded(state):
	$HelmetViewport/Viewport/Helmet.toggle_right_light(state)
	right_foot_down = state
	recalculate_rumble()

func _on_MoonWorld_player_y_rotated(value):
	$MeteorsViewport/Viewport/MoonMiniature.rotate_camera_y(value)

func stop_audio():
	$AudioPlayers/Breathing.stop()

func _on_MoonWorld_human_died(reason):
	stop_audio()
	InGameMenuController.open_menu(death_screen_packed, false)
	if InGameMenuController.current_menu.has_method("set_reason"):
		InGameMenuController.current_menu.set_reason(reason)

func _on_MoonWorld_succeeded(rest_stops):
	stop_audio()
	InGameMenuController.open_menu(success_screen_packed, false)
	if InGameMenuController.current_menu.has_method("set_rest_stops"):
		InGameMenuController.current_menu.set_rest_stops(rest_stops)


func _on_MoonWorld_player_oxygen_picked_up():
	$HelmetViewport/Viewport/Helmet.oxygen = 100


func _on_Helmet_start_asphyxiation():
	$AsphyxiationTimer.start()


func _on_Helmet_stop_asphyxiation():
	$AsphyxiationTimer.stop()


func _on_AsphyxiationTimer_timeout():
	$WorldContainer/Viewport/MoonWorld/Player.kill_human($WorldContainer/Viewport/MoonWorld/Player.DEATH_REASONS.ASPHYXIATION)


func _on_MeteorTimer_timeout():
	$HelmetViewport/Viewport/Helmet/Viewport/HUD.start_countdown()
	$LastMinTimer.start()


func _on_LastMinTimer_timeout():
	$WorldContainer/Viewport/MoonWorld/Player.kill_human($WorldContainer/Viewport/MoonWorld/Player.DEATH_REASONS.METEOR)
