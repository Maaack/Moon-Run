extends Camera
class_name PlayerCamera

signal interactable_entered(interactable_node)
signal interactable_exited(interactable_node)

var interactable : Spatial
var collider_area : Area setget set_collider_area

func set_collider_area(value : Area) -> void:
	if collider_area == value:
		return
	collider_area = value
	if collider_area == null:
		exit_interactable(interactable)
		interactable = null
		return
	interactable = collider_area.get_parent()
	if not interactable is Interactable3D or not interactable.visible:
		return
	enter_interactable(interactable)

func enter_interactable(interactable_node : Interactable3D) -> void :
	if interactable_node == null:
		return
	emit_signal("interactable_entered", interactable_node)

func exit_interactable(interactable_node : Interactable3D) -> void :
	if interactable_node == null:
		return
	emit_signal("interactable_exited", interactable_node)

func _physics_process(_delta):
	self.collider_area = $LookingAtRayCast.get_collider()
