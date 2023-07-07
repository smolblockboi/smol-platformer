class_name Attack

enum ATTACK_TYPE {PHYSICAL, MAGICAL}
var attack_type: ATTACK_TYPE = ATTACK_TYPE.PHYSICAL
var attack_damage: float
var knockback: float
var attack_position: Vector3
var attack_stun_time: float


func print_damage():
	print("Dealt %s %s damage!" % [str(attack_damage), str(ATTACK_TYPE.keys()[attack_type]).to_lower()] )
