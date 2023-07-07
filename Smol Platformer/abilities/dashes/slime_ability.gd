extends BaseAbility
class_name SlimeAbility

@onready var cast_group = $CastGroup

var sticky_state: bool = false

var walk_speed_mod: float = 0.1


func _input(event):
	if owner.is_in_group("player"):
		if !owner.is_busy:
			if Input.is_action_just_pressed("mobile_ability"):
					toggle_sticky_state()


func _physics_process(delta):
	cast_group.global_position = owner.global_position
	
	for i in cast_group.get_children():
		if i.get_collider():
			if i.get_collider().is_in_group("environment"):
				owner.up_direction = i.get_collision_normal()
	
	if sticky_state:
		if owner.state_machine.current_state.get("move_speed"):
#			owner.state_machine.current_state.move_dir.x *= walk_speed_mod
			owner.velocity *= walk_speed_mod
#			print(owner.state_machine.current_state.move_dir.x)
#			if owner.up_direction.x == 0:
#				owner.state_machine.current_state.move_speed *= walk_speed_mod
#				owner.velocity.x
#			else:
#				pass

#		if player.up_direction.x == 0:
#			player.velocity.x = move_speed * move_dir.x
#			player.rotation_degrees.z = player.up_direction.y * 90 - 90
#		else:
#			player.velocity.y = move_speed * move_dir.x
#			player.rotation_degrees.z = player.up_direction.x * -90
			
#		if owner.state_machine.current_state.get("fall_speed"):
#			if owner.up_direction.x != 0:
#				if owner.anim_player.get_current_animation() == "fly" and (
#					owner.velocity.x * owner.up_direction.x) < 0:
#
#					owner.velocity.x *= abs(owner.up_direction.x * fall_speed_mod)
#			else:
#				if owner.anim_player.get_current_animation() == "fly" and (
#					owner.velocity.y * owner.up_direction.y) < 0:
#
#					owner.velocity.y *= abs(owner.up_direction.y * fall_speed_mod)


func toggle_sticky_state():
	sticky_state = !sticky_state
	
	for i in cast_group.get_children():
		i.enabled = sticky_state
