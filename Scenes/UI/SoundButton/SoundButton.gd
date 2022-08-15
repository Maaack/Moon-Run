# a button which plays a sound effect when clicked
class_name SoundButton
extends Button

func _pressed():
	$AudioStreamPlayers/ClickSound.play()

func _on_SoundButton_mouse_entered():
	if disabled:
		return
	$AudioStreamPlayers/HoverSound.play()
