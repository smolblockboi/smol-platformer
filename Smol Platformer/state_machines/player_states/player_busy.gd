extends PlayerState
class_name PlayerBusy # player character CANNOT recieve input from controller


func enter_state():
	player = get_tree().get_first_node_in_group("player")
	player.velocity = Vector3.ZERO
	player.doing_unique_anim = true


func exit_state():
	player.doing_unique_anim = false


func process_state(_delta: float):
	pass


func physics_process_state(delta: float):
	pass
