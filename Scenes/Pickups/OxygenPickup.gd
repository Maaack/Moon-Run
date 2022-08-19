extends Area

const pivot_rotation_speed = 1
const mesh_rotation_speed = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Pivot.rotate_y(pivot_rotation_speed * delta)
	$Pivot/OxygenTank.rotate_object_local(Vector3.UP, mesh_rotation_speed * delta)


func _on_OxygenPickup_body_entered(body):
	if body.is_in_group("Player"):
		print("give oxygen")
		queue_free()
