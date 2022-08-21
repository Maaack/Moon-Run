extends KinematicBody

signal rocket_left

export(float) var engine_speed : float = 0.0

var launching : bool = false
var upwards_speed : float = 0.0

func launch() -> void:
	launching = true
	$EngineAnimationPlayer.play("ThrottleUpEngine")

func _physics_process(delta):
	if not launching:
		return
	upwards_speed += engine_speed * delta
	var vector : Vector3 = Vector3.UP * upwards_speed
	move_and_slide(vector, Vector3.UP)

func left_moon():
	emit_signal("rocket_left")
