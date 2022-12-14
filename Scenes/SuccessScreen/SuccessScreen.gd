extends CanvasLayer

const REST_STOPS_NONE_TEXT : String = "That was exhausting!!! If this somehow ever ever happens again... I'm taking a rest stop."
const REST_STOPS_ONE_TEXT : String = "Phew. Still quite tiring even with that rest stop. I should have tried for two."
const REST_STOPS_TWO_TEXT : String = "Nice. Feeling pretty good after all that rest, too."
const REST_STOPS_MORE_TEXT : String = "*Yawn* ... Now you're just making me lethargic."

var completion_time : float = 999.0 setget set_completion_time
var fastest_time : float = 999.0 setget set_fastest_time

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $Control/ConfirmExit.visible:
			$Control/ConfirmExit.hide()
		elif $Control/ConfirmMainMenu.visible:
			$Control/ConfirmMainMenu.hide()

func set_completion_time(value : float) -> void:
	completion_time = value
	$Control/EscapeTimer.text = "%0.1f sec" % value

func set_fastest_time(value : float) -> void:
	fastest_time = value
	$Control/FastestEscapeTimer.text = "%0.1f sec" % value

func set_rest_stops(rest_stops : int = 0) -> void:
	match(rest_stops):
		0:
			$Control/CommentText.text = REST_STOPS_NONE_TEXT
		1:
			$Control/CommentText.text = REST_STOPS_ONE_TEXT
		2:
			$Control/CommentText.text = REST_STOPS_TWO_TEXT
		_:
			$Control/CommentText.text = REST_STOPS_MORE_TEXT

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

func _ready():
	if OS.has_feature("web"):
		$Control/ButtonsContainer/ExitButton.hide()
