extends Area3D
class_name HurtBox


func _init():
	collision_layer = 0
	collision_mask = 2


func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitBox):
	if hitbox == null:
		return
	
	match hitbox.hit_type:
		hitbox.HIT_TYPES.DASH:
			if owner.has_method("take_dash_damage"):
				owner.take_dash_damage()
		hitbox.HIT_TYPES.JUMP:
			if owner.has_method("take_jump_damage"):
				owner.take_jump_damage()
				print(hitbox.owner.do_jump())
#				hitbox.owner.do_jump()
				hitbox.owner.do_bounce()
				hitbox.owner.refresh_jumps()
