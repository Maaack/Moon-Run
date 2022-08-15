extends Spatial

onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

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
