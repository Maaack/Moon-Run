extends Spatial

const ABANDONED_REASON = 2

signal player_camera_x_rotated(value)
signal player_camera_y_rotated(value)
signal player_camera_y_reset(duration)
signal player_left_foot_grounded(state)
signal player_right_foot_grounded(state)
signal suit_damaged(value)
signal human_died(reason)
signal human_faced(vector3)
signal succeeded(rest_stops)
signal player_oxygen_picked_up
signal message_logged(text, duration, severity)

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

func _on_Player_human_died(reason):
	emit_signal("human_died", reason)

func _on_Player_suit_damaged(value):
	emit_signal("suit_damaged", value)

func _on_Player_succeeded(rest_stops):
	emit_signal("succeeded", rest_stops)

func _on_Player_oxygen_picked_up():
	emit_signal("player_oxygen_picked_up")


func _on_RocketBody_rocket_left():
	$Player.kill_human(ABANDONED_REASON)


func _on_Player_human_faced(vector3):
	emit_signal("human_faced", vector3)


func _on_Player_message_logged(text, duration, severity):
	emit_signal("message_logged", text, duration, severity)
