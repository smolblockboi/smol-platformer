extends BaseAbility
class_name GrabAbility

@export_category("Grab Properties")
@export var grab_time: float = 0.2
var grab_max_time: float = 0.2

@export var hitbox_offset: Vector3


func _ready():
	grab_max_time = grab_time


func _input(event):
	if !owner.doing_unique_anim:
		if Input.is_action_just_pressed("attack_ability"):
				if owner.grab_marker.get_child_count() == 0:
					attempt_grab()
				else:
					attempt_throw()


func _physics_process(delta):
	if !$HitBox/CollisionShape3D.is_disabled():
		if grab_time > 0:
			grab_time -= delta
		else:
			owner.doing_unique_anim = false
			$HitBox/CollisionShape3D.set_disabled(true)
	
	if owner.facing_right:
		$HitBox.global_position = owner.global_position + hitbox_offset
	else:
		$HitBox.global_position = owner.global_position + -hitbox_offset


func attempt_grab():
	grab_time = grab_max_time
	$HitBox/CollisionShape3D.set_disabled(false)


func attempt_throw():
	owner.doing_unique_anim = true
	
	var thrown_thing = owner.grab_marker.get_child(0)
	
	thrown_thing.reparent(owner.get_parent(), true)
	
	thrown_thing.velocity = owner.velocity
	
	if owner.facing_right:
		thrown_thing.velocity += Vector3(knockback, knockback, 0)
	else:
		thrown_thing.velocity += Vector3(-knockback, knockback, 0)
	
	
	if thrown_thing.has_method("be_thrown"):
		var new_throw = Throw.new()
		new_throw.throw_damage = damage
		new_throw.throw_knockback = knockback
		new_throw.throw_orgin = owner.global_position
		new_throw.throw_stun_time = stun_time
		thrown_thing.be_thrown(new_throw)


func _on_hit_box_body_entered(body: CharacterBody3D):
	if body.is_in_group("enemy"):
		body.get_grabbed()
		body.reparent(owner.grab_marker)
		body.position = Vector3.ZERO
		$HitBox/CollisionShape3D.call_deferred("set_disabled", true)
		print("grabbed something")
