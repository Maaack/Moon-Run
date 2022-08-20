extends CanvasLayer

const IMPACT_DEATH_TEXT : String = "Rapid Decompression"
const ASPHYXIATION_DEATH_TEXT : String = "Asphyxiation"

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

func _on_ConfirmMainMenu_confirmed():
	InGameMenuController.close_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_ConfirmExit_confirmed():
	get_tree().quit()

func _on_RestartButton_pressed():
	SceneLoader.load_scene("res://Scenes/GameScene2/GameScene.tscn")

func _on_MainMenuButton_pressed():
	$Control/ConfirmMainMenu.popup_centered()

func _on_ExitButton_pressed():
	$Control/ConfirmExit.popup_centered()