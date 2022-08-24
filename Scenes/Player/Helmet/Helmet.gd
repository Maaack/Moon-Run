extends Spatial

signal start_asphyxiation
signal stop_asphyxiation

const oxygen_warning_txt = "warning: low oxygen"

onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

var oxygen = 100 setget set_oxygen
var oxygen_state : int = GameConstants.OXYGEN_STATES.SAFE


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
	$OxygenMeter.oxygen = oxygen/100.0
	if oxygen <= 0 and oxygen_state != GameConstants.OXYGEN_STATES.EMPTY:
		oxygen_state = GameConstants.OXYGEN_STATES.EMPTY
		emit_signal("start_asphyxiation")
		$Viewport/HUD.set_oxygen_empty()
		show_message("oxygen empty", 6, 2)
	elif oxygen > 0 and oxygen <= 20 and oxygen_state != GameConstants.OXYGEN_STATES.LOW:
		oxygen_state = GameConstants.OXYGEN_STATES.LOW
		$Viewport/HUD.set_oxygen_low()
		show_message("oxygen low", 6, 1)
	elif oxygen > 20 and oxygen_state != GameConstants.OXYGEN_STATES.SAFE:
		if oxygen_state == GameConstants.OXYGEN_STATES.EMPTY:
			emit_signal("stop_asphyxiation")
		oxygen_state = GameConstants.OXYGEN_STATES.SAFE
		$Viewport/HUD.set_oxygen_safe()

func _on_Timer_timeout():
	set_oxygen(oxygen-1)

func show_message(text : String, duration : float, severity : int = 0):
	match (severity):
		0:
			$Viewport/HUD.pop_up_message(text, duration)
		1:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.WARNING_COLOR)
		2, _:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.ALERT_COLOR, true)
			$WarningPlayer.play()
