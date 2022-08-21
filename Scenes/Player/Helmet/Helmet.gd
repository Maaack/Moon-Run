extends Spatial

signal start_asphyxiation
signal stop_asphyxiation

const oxygen_warning_txt = "warning: low oxygen"


onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

var oxygen = 100 setget set_oxygen
var low_oxygen_alert = false
var asphyxiating = false


func toggle_right_light(value : bool) -> void:
	$RightLight.toggle_state = value

func toggle_left_light(value : bool) -> void:
	$LeftLight.toggle_state = value

func reset_camera(delay : float = 0.5) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera_pivot, "rotation", Vector3.ZERO, 0.5)
	tween.play()

func rotate_camera_x(value : float) -> void:
	camera.rotation.x = value

func rotate_camera_y(value : float) -> void:
	camera_pivot.rotation.y = value

func set_oxygen(value):
	oxygen = value
	$OxygenMeter.oxygen = oxygen
	if low_oxygen_alert == false and oxygen < 20:
		low_oxygen_alert = true
		$Viewport/HUD.add_warning(oxygen_warning_txt)
		show_message("oxygen low", 6, 1)
	elif low_oxygen_alert == true and oxygen > 20:
		low_oxygen_alert = false
		$Viewport/HUD.remove_warning(oxygen_warning_txt)

	if oxygen <= 0 and asphyxiating == false:
		asphyxiating = true
		emit_signal("start_asphyxiation")
		show_message("oxygen empty", 10, 2)
	elif oxygen > 0 and asphyxiating == true:
		asphyxiating = false
		emit_signal("stop_asphyxiation")

func _on_Timer_timeout():
	set_oxygen(oxygen-1)

func start_run_mission():
	show_message("incoming transmission...", 2)
	yield(get_tree().create_timer(2), "timeout")
	var start_text = "incoming meteor shower\nreturn to the rocket to evacuate"
	show_message(start_text, 5, 1)
	yield(get_tree().create_timer(5), "timeout")
	$Viewport/HUD.add_objective("return to the rocket")
	show_message("run", 3.6, 2)

func show_message(text : String, duration : float, severity : int = 0):
	match (severity):
		0:
			$Viewport/HUD.pop_up_message(text, duration)
		1:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.WARNING_COLOR)
		2, _:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.ALERT_COLOR, true)
			$WarningPlayer.play()
