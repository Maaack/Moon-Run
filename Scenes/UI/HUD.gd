extends Control


const DEFAULT_COLOR = Color("08ff00")
const WARNING_COLOR = Color("ff7200")
const ALERT_COLOR = Color("ff0000")

var labels_to_display = [] # list of labels which the text need to be displayed by the timer (slow print)
var countdown : int = 60

func add_objective(objective : String):
	add(objective, $Objectives)


func modify_objective(objective : String, new_text: String):
	modify(objective, new_text, $Objectives)


func remove_objective(objective : String):
	remove(objective, $Objectives)

func set_oxygen_state(state : int = GameConstants.OXYGEN_STATES.SAFE) -> void:
	match (state):
		GameConstants.OXYGEN_STATES.EMPTY:
			$OxygenEmptyText.show()
			$OxygenLowText.hide()
		GameConstants.OXYGEN_STATES.LOW:
			$OxygenEmptyText.hide()
			$OxygenLowText.show()
		_:
			$OxygenEmptyText.hide()
			$OxygenLowText.hide()

func set_oxygen_safe() -> void:
	set_oxygen_state(GameConstants.OXYGEN_STATES.SAFE)

func set_oxygen_low() -> void:
	set_oxygen_state(GameConstants.OXYGEN_STATES.LOW)

func set_oxygen_empty() -> void:
	set_oxygen_state(GameConstants.OXYGEN_STATES.EMPTY)

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


func start_countdown(time : int = countdown) -> void:
	countdown = time
	$FinalCountdown.show()
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
	countdown -= 1
	$FinalCountdown/Timer.text = "%02d:%02d" % [floor(countdown / 60), (countdown % 60)]

func pop_up_message(text : String, duration : float = 5.0, text_color : Color = DEFAULT_COLOR, flash_flag : bool = false) -> void:
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length)
		$MessageTimer.stop()
		$CenterText.hide()
	$CenterText.text = text
	$CenterText.set("custom_colors/font_color", text_color)
	$Crosshair.hide()
	if flash_flag:
		$AnimationPlayer.play("FlashText")
	else:
		$AnimationPlayer.play("TypeText")
	$MessageTimer.wait_time = duration
	$MessageTimer.start()


func _on_MessageTimer_timeout():
	$AnimationPlayer.stop()
	$CenterText.hide()
	$Crosshair.show()
