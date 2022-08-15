extends KinematicBody

signal interactable_entered(interactable_text)
signal interactable_exited(interactable_text)
signal interacted(interactable_type)

const NONE_INTERACTABLE_TYPE = 0
const FOOTSTEP_VECTOR_MIN = 2.0
const JOGGING_VECTOR_MIN = 5.0

export(float, -60, 60) var gravity = -30.0
export(float, -10, 10) var gravity_mod : float = 1.0

onready var camera = $Pivot/PlayerCamera

var path_node_beginning
var path_node_end
var reverse_direction = false

var max_speed = 6
var stand_up_colliders : int = 0
var current_interactable

#camera vars
var mouse_sensitivity : float = 0.02  #radians/pixel
var minLookAngle : float = -90
var maxLookAngle : float = 90

var velocity = Vector3()
var mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -6))
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -6))
		camera.rotation.x = clamp(camera.rotation.x, -0.90, 1)

func _get_angle_on_y_axis(to_origin : Vector3):
	var vector_mask : Vector3 = Vector3.FORWARD + Vector3.RIGHT
	var masked_translation : Vector3 = (global_transform.origin - to_origin) * vector_mask
	var cross : Vector3 = Vector3.FORWARD.cross(masked_translation).normalized()
	var angle : float = Vector3.FORWARD.angle_to(masked_translation)
	if cross.y > 0:
		angle *= -1.0
	return angle

func _physics_process(delta):
	var is_crouched : bool = Input.is_action_pressed("crouch")
	var animation_playback : AnimationNodeStateMachinePlayback = $BodyAnimationTree.get("parameters/playback")
	if is_crouched:
		animation_playback.travel("Crouch")
	elif stand_up_colliders == 0:
		animation_playback.travel("Standing")

		
	if Input.is_action_just_pressed("jump"):
		velocity.y += 20.0


	velocity.y += (gravity * gravity_mod) * delta
	$Body.disabled = false
	var desired_velocity = get_input() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	var walk_detection : Vector3 = velocity * Vector3(1, 0, 1)
	if walk_detection.length_squared() > JOGGING_VECTOR_MIN:
		$FootstepsAnimationPlayer.play("Jogging")
	elif walk_detection.length_squared() > FOOTSTEP_VECTOR_MIN:
		$FootstepsAnimationPlayer.play("Walking")


	if Input.is_action_just_pressed("interact") and current_interactable != null:
		if current_interactable is Interactable3D:
			var interactable_type : int = current_interactable.interactable_type
			var interactable_text : String = current_interactable.interactable_text
			current_interactable.interact()
			current_interactable = null
			emit_signal("interacted", interactable_type)
			emit_signal("interactable_exited", interactable_text)


func slow_down():
	max_speed = 2

func _on_PlayerCamera_interactable_entered(interactable_node):
	current_interactable = interactable_node
	if current_interactable == null:
		return
	if current_interactable is Interactable3D:
		emit_signal("interactable_entered", current_interactable.interactable_text)

func _on_PlayerCamera_interactable_exited(interactable_node):
	if current_interactable == null or current_interactable != interactable_node:
		return
	if current_interactable is Interactable3D:
		emit_signal("interactable_exited", current_interactable.interactable_text)
	current_interactable = null

func _on_StandUpArea_body_entered(_body):
	stand_up_colliders += 1

func _on_StandUpArea_body_exited(_body):
	stand_up_colliders -= 1
	if stand_up_colliders < 0:
		stand_up_colliders = 0
