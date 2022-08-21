extends Area

signal launch_countdown

func _on_SuccessArea_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("launch_countdown")
	if body.has_method("log_message"):
		body.log_message("rocket launching!!!", 2, 1)
