extends Spatial

export(Color) var text_color : Color
export(Color) var alert_color : Color

var oxygen : float = 1.0 setget set_oxygen
var warning_level : float = 0.2
var alert : bool = false setget set_alert

func set_alert(value : bool) -> void:
	if value == alert:
		return
	alert = value
	if alert:
		$Label3D.modulate = alert_color
	else:
		$Label3D.modulate = text_color

func set_oxygen(value : float) -> void:
	oxygen = value
	var light_count = $Lights.get_child_count()
	var lights_to_activate = ceil(light_count*oxygen)
	for i in light_count:
		$Lights.get_child(i).toggle(i < lights_to_activate)
	set_alert(oxygen < warning_level)
