extends CanvasLayer

const IMPACT_DEATH_TEXT : String = "Rapid Decompression"
const ASPHYXIATION_DEATH_TEXT : String = "Asphyxiation"
const ABANDONED_DEATH_TEXT : String = "Missed Exit Window"
const METEOR_DEATH_TEXT : String = "obliteration caused by\nhigh-velocity astral body"
const EXPOSURE_DEATH_TEXT : String = "exposure to high-velocity,\nlow-altitude impact debris"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $Control/ConfirmExit.visible:
			$Control/ConfirmExit.hide()
		elif $Control/ConfirmMainMenu.visible:
			$Control/ConfirmMainMenu.hide()

func set_reason(reason : int) -> void:
	match(reason):
		0:
			$Control/Reason.text = ASPHYXIATION_DEATH_TEXT
		1:
			$Control/Reason.text = IMPACT_DEATH_TEXT
		2:
			$Control/Reason.text = ABANDONED_DEATH_TEXT
		3:
			$Control/Reason.text = METEOR_DEATH_TEXT
		4:
			$Control/Reason.text = EXPOSURE_DEATH_TEXT

func _on_ConfirmMainMenu_confirmed():
	InGameMenuController.close_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_ConfirmExit_confirmed():
	get_tree().quit()

func _on_RestartButton_pressed():
	SceneLoader.reload_current_scene()

func _on_MainMenuButton_pressed():
	$Control/ConfirmMainMenu.popup_centered()

func _on_ExitButton_pressed():
	$Control/ConfirmExit.popup_centered()
