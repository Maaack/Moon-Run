tool
extends Spatial

signal foot_grounded(value)
signal step_taken

export(float, 0, 10) var step_timer = 0.5
export(Vector3) var cast_to : Vector3 = Vector3.DOWN setget set_cast_to
export(float, 0, 50) var walk_force : float = 10.0
export(float, 0, 50) var bounce_force : float = 1.25
export(float, 0, 500) var jump_force : float = 180

var foot_grounded : bool = false setget set_foot_grounded
var is_stepping = false

func can_step() -> bool:
	return foot_grounded and not is_stepping

func set_cast_to(value : Vector3) -> void:
	if value == cast_to:
		return
	cast_to = value
	$RayCast.cast_to = cast_to
	$Footstep.translation = cast_to

func set_foot_grounded(value : bool) -> void:
	if value == foot_grounded:
		return
	foot_grounded = value
	if foot_grounded:
		$Footstep.play()
	else:
		is_stepping = false
	emit_signal("foot_grounded", value)

func step() -> void:
	if can_step():
		is_stepping = true
		$Footstep.play()
		emit_signal("step_taken")
		yield(get_tree().create_timer(step_timer), "timeout")
		is_stepping = false

func get_force_of_step(player_rotation : float, input_direction : Vector3, force_mod : float):
	if not is_stepping:
		return Vector3.ZERO
	var foot_vector : Vector3 = -$RayCast.cast_to.normalized()
	var force_of_step : Vector3 = input_direction.rotated(Vector3.UP, player_rotation) * walk_force * force_mod
	force_of_step += foot_vector * bounce_force * force_mod
	return force_of_step

func _process(delta):
	self.foot_grounded = $RayCast.is_colliding()
