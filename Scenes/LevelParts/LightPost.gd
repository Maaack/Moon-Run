tool
extends Spatial

export(Color) var light_color : Color = Color.white setget set_light_color

func set_light_color(value : Color) -> void:
	if value == light_color:
		return
	light_color = value
	var material = $MeshInstance3.get_surface_material(0).duplicate()
	material.emission = light_color
	material.albedo_color = light_color
	$OmniLight.light_color = light_color
	$MeshInstance3.set_surface_material(0, material)

