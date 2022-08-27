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
signal final_countdown_begun(time)
signal end_world

export(float, 0, 600) var world_time : float = 260.0
export(float, 0, 120) var final_countdown : float = 60.0

func _start_world_countdown():
	var time_until_final_countdown : float = world_time - final_countdown
	yield(get_tree().create_timer(time_until_final_countdown), "timeout")
	emit_signal("final_countdown_begun", final_countdown)
	yield(get_tree().create_timer(final_countdown), "timeout")
	$WorldAnimationPlayer.play("MeteorImpact")
	yield($WorldAnimationPlayer, "animation_finished")
	$Player.kill_human(METEOR_DEATH_REASON)
	emit_signal("end_world")

func _start_run_mission():
	_log_message("incoming transmission...", 2)
	yield(get_tree().create_timer(2), "timeout")
	var start_text = "incoming meteor shower\nreturn to the rocket to evacuate"
	_log_message(start_text, 5, 1)
	yield(get_tree().create_timer(5), "timeout")
	emit_signal("objective_added", "return to the rocket")
	_log_message("run", 3.6, 2)

func _launch_rocket() -> void:
	$RocketBody.launch()
	$RegolithRocketBlast.launch()
	$Interactables/WakeUpNode.wake_up()

func _start_last_room() -> void:
	$Player.translation = $PlayerLastRoomPosition.translation
	$Player.rotation = $PlayerLastRoomPosition.rotation

func _start_screenshot() -> void:
	$Player.translation = $ScreenshotPosition.translation
	$Player.rotation = $ScreenshotPosition.rotation
	$Player.gravity_scale = 0.0
	_log_message("moon run", 15)
	yield(get_tree().create_timer(5), "timeout")
	_launch_rocket()

func _ready():
	_start_world_countdown()
	_start_run_mission()

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

func _log_message(text, duration, severity = 0) -> void:
	emit_signal("message_logged", text, duration, severity)

func _on_Player_message_logged(text, duration, severity):
	_log_message(text, duration, severity)

func _on_LaunchZone_launch_countdown():
	_launch_rocket()

func _on_Player_oxygen_updated(value):
	emit_signal("player_oxygen_updated", value)
