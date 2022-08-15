tool
extends Spatial
class_name Interactable3D

signal revealed
signal hidden

enum InteractableType {
	NONE,
	RED,
	GREEN, 
	BLUE, 
	CYAN, 
	YELLOW, 
	PURPLE, 
	PINK, 
	MUSHROOM
}

enum InteractionMode {
	NONE,
	COLLISION_AREA,
	VISIBILITY_NOTIFIER
}

export(String) var interactable_text : String = ""
export(InteractableType) var interactable_type : int = InteractableType.NONE
export(InteractionMode) var interaction_mode : int = InteractionMode.NONE setget set_interaction_mode

func _update_collision_area():
	var view_collision_shape = get_node_or_null("ViewColliderArea/CollisionShape")
	if view_collision_shape == null:
		return
	view_collision_shape.disabled = (not visible) or interaction_mode != InteractionMode.COLLISION_AREA

func set_interaction_mode(value : int) -> void:
	interaction_mode = value
	_update_collision_area()

func _ready():
	self.interaction_mode = interaction_mode

func interact() -> void:
	pass

func show() -> void:
	.show()
	_update_collision_area()
	emit_signal("revealed")

func hide() -> void:
	.hide()
	_update_collision_area()
	emit_signal("hidden")

func _on_VisibilityNotifier_camera_entered(camera):
	if interaction_mode != InteractionMode.VISIBILITY_NOTIFIER:
		return
	if not camera.has_method("enter_interactable"):
		return
	if visible:
		camera.enter_interactable(self)
		connect("hidden", camera, "exit_interactable", [self])
	else:
		connect("revealed", camera, "enter_interactable", [self])

func _on_VisibilityNotifier_camera_exited(camera):
	if interaction_mode != InteractionMode.VISIBILITY_NOTIFIER:
		return
	if not camera.has_method("exit_interactable"):
		return
	if visible:
		camera.exit_interactable(self)
	if is_connected("revealed", camera, "enter_interactable"):
		disconnect("revealed", camera, "enter_interactable")
	if is_connected("hidden", camera, "exit_interactable"):
		disconnect("hidden", camera, "exit_interactable")
