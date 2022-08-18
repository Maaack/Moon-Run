extends "res://Scripts/InteractionController.gd"

signal player_camera_x_rotated(value)
signal player_camera_y_rotated(value)
signal player_camera_y_reset(duration)
signal player_left_foot_grounded(state)
signal player_right_foot_grounded(state)

func _on_Player_camera_x_rotated(value):
	emit_signal("player_camera_x_rotated", value)
	
func _on_Player_camera_y_rotated(value):
	emit_signal("player_camera_y_rotated", value)

func _on_Player_camera_y_reset(duration):
	emit_signal("player_camera_y_reset", duration)

func _on_Player_left_foot_grounded(state):
	emit_signal("player_left_foot_grounded", state)

func _on_Player_right_foot_grounded(state):
	emit_signal("player_right_foot_grounded", state)
