extends PlayerState
class_name PlayerIdle


func enter_state():
	pass


func exit_state():
	pass


func process_state(_delta: float):
	pass


func physics_process_state(delta: float):
	player_ref.move_dir = Input.get_axis("move_left", "move_right")
	
	if player_ref.is_on_floor():
		if player_ref.velocity != Vector3.ZERO:
			player_ref.anim_player.play("run")
		else:
			player_ref.anim_player.play("idle")
