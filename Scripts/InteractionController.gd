extends Spatial

var can_pause = true # to prevent from instantly repausing after unpaused from the pause menu by pressing ui_cancel

func _process(_delta):
	# cannot repause before releasing the key once
	if Input.is_action_just_pressed("ui_cancel") and can_pause:
		can_pause = false
		PauseMenuController.paused = true
	else:
		can_pause = true
