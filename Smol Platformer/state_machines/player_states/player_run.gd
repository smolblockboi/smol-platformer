extends PlayerState
class_name PlayerRun


func enter_state():
	pass


func exit_state():
	pass


func process_state(_delta: float):
	pass


func physics_process_state(delta: float):
	move_dir.x = Input.get_axis("move_left", "move_right")
	
	player.velocity.x = move_speed * move_dir.x
	
	if player.is_on_floor():
		if !player.velocity != Vector3.ZERO:
			Transitioned.emit(self, "idle")
	else:
		Transitioned.emit(self, "jump")
