extends Control


var labels_to_display = [] # list of labels which the text need to be displayed by the timer (slow print)


func _ready():
	$AnimationPlayer.play("meteor_shower_alert")


func add_objective(objective : String):
	add(objective, $Objectives)


func remove_objective(objective : String):
	remove(objective, $Objectives)


func add_warning(warning : String):
	add(warning, $Warnings)


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


func _on_AnimationPlayer_animation_finished(anim_name):
	$CenterText.visible = false
	add_objective("return to the rocket")
