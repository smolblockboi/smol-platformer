extends PlayerState
class_name PlayerIdle # player character CAN recieve input from controller

@export var move_speed: float = 5.0
var move_dir: Vector3

@export var fall_speed: float = 0.5


func enter_state():
	pass


func exit_state():
	pass


func process_state(_delta: float):
	pass


func physics_process_state(delta: float):
	move_dir.x = Input.get_axis("move_left", "move_right")
	
	if player.up_direction.x == 0:
		player.velocity.x = move_speed * move_dir.x
		player.rotation_degrees.z = player.up_direction.y * 90 - 90
	else:
		player.velocity.y = move_speed * move_dir.x
		player.rotation_degrees.z = player.up_direction.x * -90
	
	if !player.is_on_floor():
		if player.up_direction.x == 0:
			player.velocity.y += -fall_speed * player.up_direction.y
		else:
			player.velocity.x += -fall_speed * player.up_direction.x
