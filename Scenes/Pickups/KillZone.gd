tool
extends Area

export(Shape) var collision_shape : Shape setget set_collision_shape
export(int, 0, 6) var death_reason : int = 0
export(float, 0, 10) var death_delay : float = 0.0

func set_collision_shape(value : Shape) -> void:
	collision_shape = value
	var node = get_node_or_null("CollisionShape")
	if node == null:
		return
	node.shape = collision_shape

func _on_SuccessArea_body_entered(body):
	if body.has_method("kill_human"):
		body.kill_human(death_reason, death_delay)

func _ready():
	self.collision_shape = collision_shape
