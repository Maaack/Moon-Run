extends Control


onready var loader = ResourceLoader.load_interactive(SceneLoader.scene_to_load)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var err = loader.poll()
	if err == OK:
		$VBoxContainer/ProgressBar.value = loader.get_stage() * 100 / loader.get_stage_count()
	elif err == ERR_FILE_EOF:
		$VBoxContainer/ProgressBar.value = 100
		set_process(false)
		yield(get_tree().create_timer(0.1), "timeout")
		err = get_tree().change_scene_to(loader.get_resource())
		if err:
			$ErrorMsg.dialog_text = "Scene Change Error: %d" % err
			$ErrorMsg.popup_centered()
	else:
		$ErrorMsg.dialog_text = "Loading Error: %d" % err
		$ErrorMsg.popup_centered()


func _on_ErrorMsg_confirmed():
	var err = get_tree().change_scene(ProjectSettings.get_setting("application/run/main_scene"))
	if err:
		print("failed to load main scene: %d" % err)
		get_tree().quit()
