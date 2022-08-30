extends Spatial

const ABANDONED_DEATH_REASON = 2
const METEOR_DEATH_REASON = 3

signal player_camera_x_rotated(value)
signal player_camera_y_rotated(value)
signal player_camera_y_reset(duration)
signal player_left_foot_grounded(state)
signal player_right_foot_grounded(state)
signal suit_damaged(value)
signal human_died(reason)
signal human_faced(vector3)
signal succeeded(play_time, rest_stops)
signal player_oxygen_updated(value)
signal message_logged(text, duration, severity)
signal objective_added(text)

func get_key_string_for_action(action_name : String, action_iter : int = 0) -> String:
	var input_key : InputEventKey = InputMap.get_action_list(action_name)[action_iter]
	if input_key == null:
		print("no such action")
		return ""
	var scancode : int
	if input_key.physical_scancode:
		scancode = OS.keyboard_get_scancode_from_physical(input_key.physical_scancode)
	else:
		scancode = input_key.scancode
	return OS.get_scancode_string(scancode)

func _update_labels():
	for node in $Labels.get_children():
		if node is Label3D:
			var regex = RegEx.new()
			var match_string : String = "%([^%]*)%"
			regex.compile(match_string)
			var regex_matches : Array = regex.search_all(node.text)
			if regex_matches.size() == 0:
				continue
			for regex_match in regex_matches:
				var replace_string = get_key_string_for_action(regex_match.get_string(1))
				node.text = regex.sub(node.text, replace_string)


func _start_tutorial():
	_update_labels()
	_log_message("welcome to moon run training", 5)
	yield(get_tree().create_timer(3), "timeout")

func _ready():
	_start_tutorial()

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

func _on_Player_succeeded(play_time, rest_stops):
	emit_signal("succeeded", play_time, rest_stops)

func _on_RocketBody_rocket_left():
	$Player.kill_human(ABANDONED_DEATH_REASON)

func _on_Player_human_faced(vector3):
	emit_signal("human_faced", vector3)

func _log_message(text, duration = 3, severity = 0) -> void:
	emit_signal("message_logged", text, duration, severity)

func _on_Player_message_logged(text, duration, severity):
	_log_message(text, duration, severity)


func _on_Player_oxygen_updated(value):
	emit_signal("player_oxygen_updated", value)
