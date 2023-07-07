extends PlayerState
class_name PlayerJump

#@export var fall_speed: float = -0.5
@export var jump_power: float = 8.5


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
		Transitioned.emit(self, "idle")
	else:
		player.velocity.y += -fall_speed
