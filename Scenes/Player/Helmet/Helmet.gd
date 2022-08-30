extends Spatial

signal start_asphyxiation
signal stop_asphyxiation

export(float, 0, 1) var low_oxygen_threshold : float = 0.2

onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

var oxygen : float = 1.0 setget set_oxygen
var oxygen_state : int = GameConstants.OXYGEN_STATES.SAFE
var timer_running : bool = false
var run_timer : float = 0.0

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
	if oxygen <= 0 and oxygen_state != GameConstants.OXYGEN_STATES.EMPTY:
		oxygen_state = GameConstants.OXYGEN_STATES.EMPTY
		$Viewport/HUD.set_oxygen_empty()
		show_message("oxygen empty", 6, 2)
	elif oxygen > 0 and oxygen <= low_oxygen_threshold and oxygen_state != GameConstants.OXYGEN_STATES.LOW:
		oxygen_state = GameConstants.OXYGEN_STATES.LOW
		$Viewport/HUD.set_oxygen_low()
		show_message("oxygen low", 6, 1)
	elif oxygen > low_oxygen_threshold and oxygen_state != GameConstants.OXYGEN_STATES.SAFE:
		oxygen_state = GameConstants.OXYGEN_STATES.SAFE
		$Viewport/HUD.set_oxygen_safe()

func show_message(text : String, duration : float, severity : int = 0):
	match (severity):
		0:
			$Viewport/HUD.pop_up_message(text, duration)
		1:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.WARNING_COLOR)
		2, _:
			$Viewport/HUD.pop_up_message(text, duration, $Viewport/HUD.ALERT_COLOR, true)
			$WarningPlayer.play()

func start_timer() -> void:
	run_timer = 0.0
	timer_running = true

func add_to_timer(delta : float) -> void:
	if not timer_running:
		return
	run_timer += delta
	var minutes = floor(run_timer / 60)
	var seconds = run_timer - (minutes * 60.0)
	var new_text = "%02d:%04.1f" % [minutes, seconds]
	if $RunCounter.text != new_text:
		$RunCounter.text = new_text

func _process(delta):
	add_to_timer(delta)

func quiet_helmet():
	$WarningPlayer.volume_db = linear2db(0.02)
	$WarningPlayer.pitch_scale = 0.75

func kill_helmet():
	hide()
	set_process(false)
