extends EnemyState
class_name EnemyPatrol


@export var patrol_time: float = 5.0
var current_patrol_time: float


func enter_state():
	current_patrol_time = patrol_time
	player_ref = get_tree().get_first_node_in_group("player")


func exit_state():
	pass


#func process_state(_delta: float):
#	pass


func physics_process_state(delta: float):
	var dir = player_ref.global_position - enemy.global_position
	
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.fall_speed
	
	if dir.length() > (detect_range * 0.33):
		enemy.velocity.x = dir.normalized().x * enemy.move_speed
	else:
		enemy.velocity.x = 0
	
	if dir.length() > detect_range:
		enemy.velocity.x = 0
		if current_patrol_time > 0:
			current_patrol_time -= delta
		else:
			Transitioned.emit(self, "idle")
	else:
		Transitioned.emit(self, "follow")
