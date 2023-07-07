extends Area3D
class_name AbilityPickup

enum POWER_TYPES {JUMP, MOBILITY, ATTACK}
@export var power_type: POWER_TYPES
var power_pickup: Node

var disabled_time = 0.2


func _process(delta):
	if disabled_time > 0:
		disabled_time -= delta
	else:
		$CollisionShape3D.set_disabled(false)


func _on_body_entered(body):
	if body.is_in_group("player"):
		if power_pickup:
			match power_type:
				POWER_TYPES.JUMP:
					if body.current_jump_ability_ref.get_children().size() > 0:
						var current_ability_level = body.current_jump_ability_ref.get_child(0).level
						if power_pickup.level >= current_ability_level:
							for i in body.current_jump_ability_ref.get_children():
								i.queue_free()
							body.current_jump_ability_ref.add_child(power_pickup)
							power_pickup.set_owner(body)
					else:
						body.current_jump_ability_ref.add_child(power_pickup)
						power_pickup.set_owner(body)
				
				POWER_TYPES.MOBILITY:
					if body.current_mobility_ability_ref.get_children().size() > 0:
						var current_ability_level = body.current_mobility_ability_ref.get_child(0).level
						if power_pickup.level >= current_ability_level:
							for i in body.current_mobility_ability_ref.get_children():
								i.queue_free()
							body.current_mobility_ability_ref.add_child(power_pickup)
							power_pickup.set_owner(body)
					else:
						body.current_mobility_ability_ref.add_child(power_pickup)
						power_pickup.set_owner(body)
				
				POWER_TYPES.ATTACK:
					if body.current_attack_ability_ref.get_children().size() > 0:
						var current_ability_level = body.current_attack_ability_ref.get_child(0).level
						if power_pickup.level >= current_ability_level:
							for i in body.current_attack_ability_ref.get_children():
								i.queue_free()
							body.current_attack_ability_ref.add_child(power_pickup)
							power_pickup.set_owner(body)
					else:
						body.current_attack_ability_ref.add_child(power_pickup)
						power_pickup.set_owner(body)
						
			
			power_pickup.change_into_costume.emit()
			print("picked up %s!" % power_pickup.name)
			
			queue_free()
