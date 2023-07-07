extends EnemyState
class_name EnemyStunned

var impact_dir: Vector3
var stun_time: float = 1.0
var stun_knockback: float = 1.0
var knockback_time: float = 1.0


func enter_state():
	player_ref = get_tree().get_first_node_in_group("player")
	enemy.can_sprite_flip = false
	enemy.anim_player.play("stunned")


func exit_state():
	enemy.can_sprite_flip = true


#func process_state(delta: float):
	pass


func physics_process_state(delta: float):
	var dir = player_ref.global_position - enemy.global_position
	
	if stun_time > 0:
		stun_time -= delta
		if knockback_time > 0:
			knockback_time -= delta
			enemy.velocity.x = (enemy.global_position - impact_dir).normalized().x * stun_knockback
		else:
			if enemy.is_on_floor():
				enemy.velocity.x = 0
	else:
		Transitioned.emit(self, "idle")
	
	if !enemy.is_on_floor():
		enemy.velocity.y += enemy.fall_speed
