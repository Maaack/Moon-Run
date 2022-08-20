extends Spatial

onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

func rotate_camera_x(value : float) -> void:
	camera.rotation.x = value

func rotate_camera_y(value : float) -> void:
	camera_pivot.rotation.y = value
