extends EnemyState
class_name EnemyFollow

@export var follow_distance: float = 1.0


func enter_state():
	player_ref = get_tree().get_first_node_in_group("player")


func exit_state():
	pass


#func process_state(_delta: float):
#	pass


func physics_process_state(delta: float):
	var dir = player_ref.global_position - enemy.global_position
	
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.fall_speed
	
	if dir.length() > follow_distance:
		enemy.velocity.x = dir.normalized().x * enemy.move_speed
	else:
		enemy.velocity.x = 0
	
	if dir.length() > detect_range:
		Transitioned.emit(self, "patrol")
