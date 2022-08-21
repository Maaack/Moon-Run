extends RigidBody

enum DEATH_REASONS{
	ASPHYXIATION,
	IMPACT,
	ABANDONED,
	EXPOSED
} 

signal camera_x_rotated(value)
signal camera_y_rotated(value)
signal human_faced(vector3)
signal camera_y_reset(duration)
signal left_foot_grounded(state)
signal right_foot_grounded(state)
signal suit_damaged(value)
signal human_died(reason)
signal succeeded(rest_stops)
signal oxygen_picked_up

export(float) var mouse_sensitivity : float = 0.02

onready var camera_pivot = $Pivot
onready var camera = $Pivot/PlayerCamera
onready var left_arm = $Arms/LeftRayCast
onready var right_arm = $Arms/RightRayCast
var forward_movement_vector : Vector3 = Vector3.FORWARD
var bounce_movement_vector : Vector3 = Vector3.UP
var bounce_force : float = 2.5
var jump_force : float = 360.0
var turn_force : float = 1.0
var rotate_y_force : float = 0.0
var angular_damp_per_contact : float = 3.0
var linear_damp_per_contact : float = 0.25
var free_look_mode : bool = false setget set_free_look_mode
var previous_forces : Vector3
var impact_force_resistance : float = 75000
var impact_force_kills : float = 150000
var suit_damage : float = 0.0
var left_foot_grounded : bool = false
var right_foot_grounded : bool = false
var left_arm_contacting : bool = false
var right_arm_contacting : bool = false
var controls_frozen : bool = false
var run_time : float = 0.0
var real_run_time : float = 0.0
var rest_stops : int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _get_linear_damp_by_contacts() -> float:
	var total_linear_damp : float = 0
	total_linear_damp = int(left_foot_grounded) + int(right_foot_grounded)
	total_linear_damp *= linear_damp_per_contact
	return total_linear_damp

func _get_angular_damp_by_contacts() -> float:
	var total_angular_damp : float = 0
	total_angular_damp = int(left_foot_grounded) + int(right_foot_grounded) + int(left_arm_contacting) + int(right_arm_contacting)
	total_angular_damp *= angular_damp_per_contact
	return total_angular_damp

func _both_feet_can_reach_ground():
	return left_foot_grounded and right_foot_grounded

func _can_reach_ground():
	return left_foot_grounded or right_foot_grounded or left_arm_contacting or right_arm_contacting

func _get_spatial_origin_relative(node : Spatial):
		return node.global_transform.origin - global_transform.origin

func set_free_look_mode(value : bool) -> void:
	if value == free_look_mode:
		return
	free_look_mode = value
	var duration : float = 0.5
	if not free_look_mode and camera_pivot.rotation.y != 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property(camera_pivot, "rotation", Vector3.ZERO, duration)
		tween.play()
		emit_signal("camera_y_reset", duration)

func rest() -> void:
	run_time += 30.0
	rest_stops += 1

func add_play_time(delta : float) -> void:
	run_time += delta
	real_run_time += delta

func succeed() -> void:
	controls_frozen = true
	emit_signal("succeeded", rest_stops)

func kill_human(reason : int) -> void:
	if controls_frozen:
		return
	controls_frozen = true
	emit_signal("human_died", reason)
	match(reason):
		1:
			$CrackedHelmet.play()
	axis_lock_angular_x = false
	axis_lock_angular_z = false
	var random_angular_velocity = Vector3(rand_range(-0.5, 0.5),rand_range(-0.5, 0.5),rand_range(-0.5, 0.5))
	angular_velocity = random_angular_velocity

func damage_suit(amount : float) -> void:
		emit_signal("suit_damaged", amount)
		suit_damage += amount

func pickup_oxygen():
	emit_signal("oxygen_picked_up")

func dive():
	$DivingAnimationPlayer.play("Dive")

func _process(delta):
	add_play_time(delta)
	self.left_arm_contacting = left_arm.is_colliding()
	self.right_arm_contacting = right_arm.is_colliding()
	linear_damp = _get_linear_damp_by_contacts()
	angular_damp = _get_angular_damp_by_contacts()
	self.free_look_mode = not _can_reach_ground() or Input.is_action_pressed("free_look")
	emit_signal("human_faced", camera.global_rotation)

func _input(event):
	if controls_frozen:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y_force = -event.relative.x * mouse_sensitivity * turn_force
		if free_look_mode:
			camera_pivot.rotate_y(deg2rad(rotate_y_force))
			camera_pivot.rotation.y = clamp(camera_pivot.rotation.y, -1, 1)
			emit_signal("camera_y_rotated", camera_pivot.rotation.y)
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -6))
		camera.rotation.x = clamp(camera.rotation.x, -0.90, 1)
		emit_signal("camera_x_rotated", camera.rotation.x)

func _get_input_direction():
	var total_input_direction : Vector3
	if Input.is_action_pressed("move_forward"):
		total_input_direction += Vector3.FORWARD
	if Input.is_action_pressed("move_back"):
		total_input_direction += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		total_input_direction += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		total_input_direction += Vector3.RIGHT
	return total_input_direction.normalized()

func _play_suit_impact(impact_force : float) -> void:
	var impact_ratio : float = impact_force / impact_force_resistance
	if impact_ratio < 0.75:
		return
	var loudness : float = 0.2
	loudness += clamp(impact_ratio, 1, 6) / 10.0
	$SuitImpact.volume_db = linear2db(loudness)
	$SuitImpact.play()

func _integrate_forces(state):
	if controls_frozen:
		return
	var forces : Vector3 = state.get_linear_velocity() / state.get_inverse_mass() / state.get_step()
	var forces_delta : Vector3 = forces - previous_forces
	var impact_force : float = forces_delta.length()
	if impact_force > impact_force_kills:
		kill_human(DEATH_REASONS.IMPACT)
	elif impact_force > impact_force_resistance:
		var current_damage : float = impact_force/impact_force_resistance
		damage_suit(current_damage)
	_play_suit_impact(impact_force)
	previous_forces = forces
	rotate_y_force += rad2deg(camera_pivot.rotation.y) * 0.01
	if rotate_y_force != 0.0 and not free_look_mode:
		state.add_torque(Vector3(0, rotate_y_force, 0) * mass)
	rotate_y_force = 0.0
	if Input.is_action_pressed("jump") and _both_feet_can_reach_ground():
		var jump_impulse : Vector3 = bounce_movement_vector * jump_force * mass
		state.add_central_force(bounce_movement_vector * jump_force * mass)
	var input_direction : Vector3 = _get_input_direction()
	if input_direction != Vector3.ZERO:
		if $RightLegControl.can_step():
			$RightLegControl.step()
		if $LeftLegControl.can_step():
			$LeftLegControl.step()
		state.add_central_force($RightLegControl.get_force_of_step(rotation.y, input_direction, mass))
		state.add_central_force($LeftLegControl.get_force_of_step(rotation.y, input_direction, mass))

func _on_LeftLegControl_foot_grounded(value):
	left_foot_grounded = value
	emit_signal("left_foot_grounded", value)

func _on_RightLegControl_foot_grounded(value):
	right_foot_grounded = value
	emit_signal("right_foot_grounded", value)
