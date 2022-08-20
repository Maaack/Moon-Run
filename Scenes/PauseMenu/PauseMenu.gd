extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $ConfirmExit.visible:
			$ConfirmExit.hide()
		elif $ConfirmMainMenu.visible:
			$ConfirmMainMenu.hide()
		elif $OptionsMenu.visible:
			$OptionsMenu.visible = false
			$ButtonsContainer.visible = true
		else:
			InGameMenuController.close_menu()


func _on_ResumeBtn_pressed():
	InGameMenuController.close_menu()


func _on_OptionsBtn_pressed():
	$ButtonsContainer.visible = false
	$OptionsMenu.visible = true


func _on_MainMenuBtn_pressed():
	$ConfirmMainMenu.popup_centered()


func _on_ExitBtn_pressed():
	$ConfirmExit.popup_centered()


func _on_ConfirmMainMenu_confirmed():
	InGameMenuController.close_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")


func _on_ConfirmExit_confirmed():
	get_tree().quit()
