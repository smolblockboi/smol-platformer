extends PlayerState
class_name PlayerGrab

@export var grab_time: float = 0.2
var max_grab_time: float = 0.2
var stored_velocity: Vector3


func enter_state():
	player = get_tree().get_first_node_in_group("player")
	stored_velocity = player.velocity
	grab_time = max_grab_time


func exit_state():
	pass


func process_state(_delta: float):
	pass


func physics_process_state(delta: float):
	if grab_time > 0:
		grab_time -= delta
		player.velocity = Vector3.ZERO
	else:
		player.velocity = stored_velocity
		Transitioned.emit(self, "idle")
