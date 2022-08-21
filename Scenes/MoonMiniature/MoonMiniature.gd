extends Spatial

onready var camera_pivot : Spatial = $CameraPivot
onready var camera : Spatial = $CameraPivot/Camera

func rotate_camera_x(value : float) -> void:
	camera.rotation.x = value

func rotate_camera_y(value : float) -> void:
	camera_pivot.rotation.y = value

func rotate_camera(vector3 : Vector3) -> void:
	camera.rotation.x = vector3.x
	camera_pivot.rotation.y = vector3.y
	camera_pivot.rotation.z = vector3.z
