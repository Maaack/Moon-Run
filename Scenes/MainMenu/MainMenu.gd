extends Control


var sub_menu


func open_sub_menu(menu : Control):
	$Main.visible = false
	menu.visible = true
	sub_menu = $OptionsMenu
	$BackButton.visible = true


func _on_Play_pressed():
	SceneLoader.load_scene("res://Scenes/GameScene/GameScene.tscn")


func _on_Options_pressed():
	open_sub_menu($OptionsMenu)


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	if sub_menu:
		$BackButton.visible = false
		sub_menu.visible = false
		$Main.visible = true
		sub_menu = null
