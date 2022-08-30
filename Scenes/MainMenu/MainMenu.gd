extends Control


var sub_menu


func open_sub_menu(menu : Control):
	$MarginContainer/Main.visible = false
	menu.visible = true
	sub_menu = menu
	$BackButton.visible = true


func _on_Play_pressed():
	SceneLoader.load_scene("res://Scenes/GameScene/GameScene.tscn")

func _on_Options_pressed():
	open_sub_menu($OptionsMenu)


func _on_Credits_pressed():
	open_sub_menu($Credits)
	$Credits.set_header_and_footer()
	$Credits.set_process(true)


func _on_Exit_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	if sub_menu:
		$BackButton.visible = false
		sub_menu.visible = false
		$MarginContainer/Main.visible = true
		sub_menu = null

func _input(event):
	if (event is InputEventMouseButton or event is InputEventKey):
		$AnimationPlayer.seek(5.0)


func _on_Tutorial_pressed():
	SceneLoader.load_scene("res://Scenes/TutorialScene/TutorialScene.tscn")
