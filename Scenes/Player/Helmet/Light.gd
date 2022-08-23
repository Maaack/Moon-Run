tool
extends Spatial


export(Color) var on_color : Color
export(Material) var on_material : Material
export(Color) var off_color : Color
export(Material) var off_material : Material
export(bool) var toggle_state : bool = false setget toggle

func toggle(value : bool) -> void:
	if value == toggle_state: return # return if trying to set the same color (performance hit in oxygen hud which update often)
	toggle_state = value
	var new_color : Color 
	var new_material : Material 
	if toggle_state:
		new_color = on_color
		new_material = on_material
	else:
		new_color = off_color
		new_material = off_material
	$OmniLight.light_color = new_color
	$LightSurface.material = new_material
	$LightSurface/InteriorSurface.material = new_material

func _ready():
	self.toggle_state = toggle_state
