extends Node

func wake_up():
	for node in get_children():
		if node is RigidBody:
			node.can_sleep = false
			node.sleeping = false
