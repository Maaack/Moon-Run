extends Control


const DEFAULT_COLOR = Color("08ff00")
const WARNING_COLOR = Color("ff7200")
const ALERT_COLOR = Color("ff0000")

var labels_to_display = [] # list of labels which the text need to be displayed by the timer (slow print)
var countdown = 60
var countdown_text = "alert: meteor striking in 01:00"

var start_text = "incoming meteor shower\nreturn to the rocket to evacuate"

func start_run_mission():
	pop_up_message("incoming transmission...", 2)
	yield(get_tree().create_timer(2), "timeout")
	pop_up_message(start_text, 5, WARNING_COLOR)
	yield(get_tree().create_timer(5), "timeout")
	add_objective("return to the rocket")
	pop_up_message("run", 3.6, ALERT_COLOR, true)

func add_objective(objective : String):
	add(objective, $Objectives)


func modify_objective(objective : String, new_text: String):
	modify(objective, new_text, $Objectives)


func remove_objective(objective : String):
	remove(objective, $Objectives)


func add_warning(warning : String):
	add(warning, $Warnings)


func modify_warning(warning : String, new_text : String):
	modify(warning, new_text, $Warnings)


func modify(text, new_text, container):
	for label in container.get_children():
		if label.text == text:
			label.text = new_text
			return


func remove_warning(warning : String):
	remove(warning, $Warnings)


func add(text, container):
	var label = Label.new()
	label.visible_characters = 0
	label.text = text
	container.add_child(label)
	labels_to_display.append(label)


func remove(text, container):
	for label in container.get_children():
		if label.text == text:
			label.queue_free()
			return


func start_countdown():
	add_objective(countdown_text)
	$CountdownTimer.start()


func _on_Timer_timeout():
	var labels_finished_display = []
	
	for i in range(labels_to_display.size()):
		var label = labels_to_display[i]
		if label.visible_characters < label.text.length():
			label.visible_characters += 1
		else:
			labels_finished_display.append(i)
	
	for pos in labels_finished_display:
		labels_to_display.remove(pos)


func _on_CountdownTimer_timeout():
	var old_countdown_text = countdown_text
	countdown -= 1
	countdown_text = "alert: meteor striking in 00:%2d" % countdown
	modify_objective(old_countdown_text, countdown_text)

func pop_up_message(text : String, duration : float = 5.0, text_color : Color = DEFAULT_COLOR, flash_flag : bool = false) -> void:
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length)
		$CenterText.hide()
	$CenterText.text = text
	$CenterText.set("custom_colors/font_color", text_color)
	if flash_flag:
		$AnimationPlayer.play("FlashText")
	else:
		$AnimationPlayer.play("TypeText")
	yield(get_tree().create_timer(duration), "timeout")
	$AnimationPlayer.stop()
	$CenterText.hide()
	
