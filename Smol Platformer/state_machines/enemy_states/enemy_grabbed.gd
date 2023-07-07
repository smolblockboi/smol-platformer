extends EnemyState
class_name EnemyGrabbed


func enter_state():
	enemy.collision_shape_node.call_deferred("set_disabled", true)


func exit_state():
	enemy.collision_shape_node.call_deferred("set_disabled", false)


func process_state(delta: float):
	pass


func physics_process_state(delta: float):
	if enemy:
		enemy.velocity = Vector3.ZERO
