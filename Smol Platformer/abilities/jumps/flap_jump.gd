extends JumpAbility
class_name FlapJump

@export var fall_speed_mod = 0.85
@export var jump_mod_increment: float = 0.75


func _ready():
	refresh_cooldown.connect(refresh_jumps)


func _physics_process(delta):
	if !owner.is_busy:
		if Input.is_action_just_pressed("jump"):
			attempt_jump()
	
	$HitBox/CollisionShape3D.disabled = owner.is_on_floor()
	
	if owner.is_on_floor():
		$HitBox/CollisionShape3D.position = owner.position
		if !owner.is_busy:
			owner.doing_unique_anim = false
		jump_count = 0
	else:
		$HitBox/CollisionShape3D.position = owner.position - hitbox_offset
		
		if Input.is_action_just_pressed("move_down"):
				owner.doing_unique_anim = false
		
		if owner.state_machine.current_state.get("fall_speed"):
			if owner.up_direction.x != 0:
				if owner.anim_player.get_current_animation() == "fly" and (
					owner.velocity.x * owner.up_direction.x) < 0:
						
					owner.velocity.x *= abs(owner.up_direction.x * fall_speed_mod)
			else:
				if owner.anim_player.get_current_animation() == "fly" and (
					owner.velocity.y * owner.up_direction.y) < 0:
						
					owner.velocity.y *= abs(owner.up_direction.y * fall_speed_mod)


func attempt_jump():
	if owner.is_on_floor():
		jump_power_mod = max_jump_power_mod
		if allow_air_jump:
			jump_count -= 1
		do_jump()
	else:
		if allow_air_jump and jump_count < max_jumps:
			owner.doing_unique_anim = true
			owner.anim_player.play("fly")
			do_jump()
			if owner.doing_unique_anim and !owner.is_on_floor():
				await owner.anim_player.animation_finished
				owner.doing_unique_anim = false


func do_jump():
	jump_audio_node.play(0.0)
	jump_count += 1
	owner.velocity = owner.up_direction * (jump_power * jump_power_mod)
	jump_power_mod *= jump_mod_increment

