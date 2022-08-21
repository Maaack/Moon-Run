extends Area

signal launch_countdown

func _on_SuccessArea_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("launch_countdown")
