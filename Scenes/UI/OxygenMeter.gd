extends Spatial

const green_color = Color("#08ff00")
const red_color = Color("#ff1200")

var oxygen = 100 setget set_oxygen


func set_oxygen(value : int):
	oxygen = value
	var nb_lights_to_activate = floor(oxygen/20) as int
	for i in range(5):
		$Lights.get_child(i).toggle(i <= nb_lights_to_activate)


func _on_Timer_timeout():
	set_oxygen(oxygen-1)
