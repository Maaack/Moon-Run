extends Spatial

const green_color = Color("#08ff00")
const red_color = Color("#ff1200")

var oxygen = 100 setget set_oxygen


func set_oxygen(value : int):
	oxygen = value
	var nb_lights_to_activate = floor((oxygen+19)/20) as int # the +19 is here so the nb_lights is 1-5 and 0 means shut all,
#else at 0 the first one stays on
	for i in range(5):
		$Lights.get_child(i).toggle(i < nb_lights_to_activate)
	$Label3D.modulate = green_color if oxygen > 0 else red_color

