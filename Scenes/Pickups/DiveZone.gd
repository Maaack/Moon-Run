extends Area

func _on_SuccessArea_body_entered(body):
	if body.has_method("dive"):
		body.dive()
