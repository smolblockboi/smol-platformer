extends BaseAbility
class_name DashAbility

@export_category("Dash Properties")
@export var max_dash: int = 1
var dash_count: int = 0

@export var dash_time: float = 0.3
var dash_tick: float = 0.0
@export var dash_speed: float = 9.0

@export var allow_in_air: bool = false

var hitbox_offset: float = 0.35

var is_active: bool = false


func _input(event):
	if owner.is_in_group("player"):
		if !owner.is_busy:
			if Input.is_action_just_pressed("mobile_ability"):
					attempt_dash()


func _physics_process(delta):
	if owner.is_on_floor():
		dash_count = 0
	
	$HitBox/CollisionShape3D.disabled = !is_active
	
	if is_active:
		match owner.facing_right:
			true:
				$HitBox/CollisionShape3D.position.x = owner.position.x + hitbox_offset
			false:
				$HitBox/CollisionShape3D.position.x = owner.position.x - hitbox_offset
		if dash_tick < dash_time:
			dash_tick += delta
		else:
			is_active = false
			dash_tick = 0.0
			owner.is_busy = is_active
			owner.velocity = Vector3.ZERO
			owner.doing_unique_anim = false
			owner.state_machine.current_state.Transitioned.emit(owner.state_machine.current_state, "Idle")
	else:
		$HitBox/CollisionShape3D.position = owner.position


func attempt_dash():
	if !is_active:
		if dash_count < max_dash:
			if allow_in_air:
				is_active = true
			elif owner.is_on_floor():
				is_active = true
			
			if is_active:
				owner.is_busy = is_active
				match owner.facing_right:
					true:
						do_dash(Vector3.RIGHT.x)
						print("dashed right")
					false:
						do_dash(Vector3.LEFT.x)
						print("dashed left")


func do_dash(dash_dir):
	owner.state_machine.current_state.Transitioned.emit(owner.state_machine.current_state, "Busy")
	
	dash_count += 1
	owner.doing_unique_anim = true
	owner.anim_player.play("dash")
	owner.velocity.x = dash_dir * dash_speed
	owner.velocity.y = 0
	print("dash_count = %s" % dash_count)


func refresh_dashes():
	dash_count = 0


func _on_hit_box_body_entered(body):
	if body.has_method("take_damage"):
		owner.velocity = Vector3.ZERO
		
		var new_attack = Attack.new()
		new_attack.attack_damage = damage
		new_attack.knockback = knockback
		new_attack.attack_position = owner.global_position
		new_attack.attack_stun_time = stun_time
		body.take_damage(new_attack)

