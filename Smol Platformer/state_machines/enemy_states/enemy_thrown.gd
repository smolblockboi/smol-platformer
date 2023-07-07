extends EnemyState
class_name EnemyThrown

var origin: Vector3 # thrown from here
var air_time: float = 1.0 # time spent in state
var thrown_strength: float = 1.0 # distance thrown


func enter_state():
	if enemy:
		print("wee!")
		enemy.anim_player.play("roll")


func exit_state():
	if get_parent().current_state.get("stun_time"):
		print("ha")
		get_parent().current_state.stun_time = air_time


#func process_state(delta: float):
#	pass


func physics_process_state(delta: float):
	if enemy:
		if air_time > 0:
			air_time -= delta
			if enemy.is_on_floor():
				enemy.velocity.x = 0
				enemy.anim_player.play("sit")
#				Transitioned.emit(self, "stunned")
			else:
				enemy.velocity.y += enemy.fall_speed
		else:
			Transitioned.emit(self, "idle")
