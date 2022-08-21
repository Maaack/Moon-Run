tool
extends Area

export(Shape) var collision_shape : Shape setget set_collision_shape
export(String, MULTILINE) var message_text : String = "message here"
export(float, 0.0, 15.0) var message_duration : float = 3.0
export(int, 0, 5) var message_severity : int = 0

func set_collision_shape(value : Shape) -> void:
	collision_shape = value
	var node = get_node_or_null("CollisionShape")
	if node == null:
		return
	node.shape = collision_shape

func _on_SuccessArea_body_entered(body):
	if body.has_method("log_message"):
		body.log_message(message_text, message_duration, message_severity)

func _ready():
	self.collision_shape = collision_shape
