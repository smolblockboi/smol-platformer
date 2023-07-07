class_name Throw

var throw_damage: float # damage delt
var throw_knockback: float # distance thrown
var throw_orgin: Vector3
var throw_stun_time: float # throw air time 


func print_damage():
	print("Threw for %s damage!" % str(throw_damage))
