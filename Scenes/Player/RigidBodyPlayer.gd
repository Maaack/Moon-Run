extends RigidBody

signal camera_x_rotated(value)
signal camera_y_rotated(value)
signal camera_y_reset(duration)
signal left_foot_grounded(state)
signal right_foot_grounded(state)

export(float) var mouse_sensitivity : float = 0.02

onready var camera_pivot = $Pivot
onready var camera = $Pivot/PlayerCamera
onready var left_leg = $Legs/LeftRayCast
onready var right_leg = $Legs/RightRayCast
onready var left_arm = $Arms/LeftRayCast
onready var right_arm = $Arms/RightRayCast
var forward_movement_vector : Vector3 = Vector3.FORWARD
var bounce_movement_vector : Vector3 = Vector3.UP
var bounce_force : float = 2.5
var jump_force : float = 360.0
var walk_force : float = 12.0
var turn_force : float = 1.0
var rotate_y_force : float = 0.0
var angular_damp_per_contact : float = 3.0
var linear_damp_per_contact : float = 0.25
var free_look_mode : bool = false setget set_free_look_mode

var left_foot_grounded : bool = false setget set_left_foot_grounded
var right_foot_grounded : bool = false setget set_right_foot_grounded
var left_arm_contacting : bool = false
var right_arm_contacting : bool = false

func set_left_foot_grounded(value : bool) -> void:
	if value == left_foot_grounded:
		return
	left_foot_grounded = value
	emit_signal("left_foot_grounded", value)

func set_right_foot_grounded(value : bool) -> void:
	if value == right_foot_grounded:
		return
	right_foot_grounded = value
	emit_signal("right_foot_grounded", value)

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

func _process(delta):
	self.left_foot_grounded = left_leg.is_colliding()
	self.right_foot_grounded = right_leg.is_colliding()
	self.left_arm_contacting = left_arm.is_colliding()
	self.right_arm_contacting = right_arm.is_colliding()
	linear_damp = _get_linear_damp_by_contacts()
	angular_damp = _get_angular_damp_by_contacts()
	if not _can_reach_ground() or Input.is_action_pressed("free_look"):
		self.free_look_mode = true
	else:
		self.free_look_mode = false

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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

func _integrate_forces(state):
	rotate_y_force += rad2deg(camera_pivot.rotation.y) * 0.01
	if rotate_y_force != 0.0 and not free_look_mode:
		state.add_torque(Vector3(0, rotate_y_force, 0) * mass)
	rotate_y_force = 0.0
	if Input.is_action_pressed("jump") and _both_feet_can_reach_ground():
		var jump_impulse : Vector3 = bounce_movement_vector * jump_force * mass
		state.add_central_force(bounce_movement_vector * jump_force * mass)
	var input_direction : Vector3 = _get_input_direction()
	if input_direction != Vector3.ZERO:
		if right_foot_grounded:
			var foot_vector : Vector3 = -right_leg.cast_to.normalized()
			var next_impulse : Vector3 = input_direction.rotated(Vector3.UP, rotation.y) * walk_force * mass
			next_impulse += foot_vector * bounce_force * mass
			state.add_central_force(next_impulse)
		if left_foot_grounded:
			var foot_vector : Vector3 = -left_leg.cast_to.normalized()
			var next_impulse : Vector3 = input_direction.rotated(Vector3.UP, rotation.y) * walk_force * mass
			next_impulse += foot_vector * bounce_force * mass
			state.add_central_force(next_impulse)
