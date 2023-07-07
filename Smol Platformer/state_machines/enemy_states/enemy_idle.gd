extends EnemyState
class_name EnemyIdle

var move_dir: Vector3
var wander_time: float
var wait_time: float


func randomize_wander():
	move_dir = Vector3(randf_range(-1, 1), enemy.velocity.y, 0).normalized()
	wander_time = randf_range(0.5, 1)
	wait_time = randf_range(1.0, 2.0)


func turn_around():
	move_dir.x *= -1


func enter_state():
	player_ref = get_tree().get_first_node_in_group("player")


func exit_state():
	pass


func process_state(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		if wait_time > 0:
			wait_time -= delta
		else:
			randomize_wander()


func physics_process_state(delta: float):
	if enemy:
		if wander_time > 0:
			if enemy.is_on_wall():
				turn_around()
				
			enemy.velocity.x = move_dir.x * (enemy.move_speed * 0.75)
		
		elif wait_time > 0:
			enemy.velocity.x = 0
	
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.fall_speed
	
	var dir = player_ref.global_position - enemy.global_position
	
	if dir.length() < detect_range:
		Transitioned.emit(self, "follow")
