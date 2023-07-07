extends BaseAbility
class_name JumpAbility

signal bounced

@export_category("Jump Properties")
@export var max_jumps: int = 1
var jump_count: int = 0

@export var jump_power: float = 8.5
@export var jump_power_mod: float = 1.0
var max_jump_power_mod: float = 1.0
@export var allow_air_jump: bool = false

@onready var jump_audio_node: AudioStreamPlayer = $JumpAudio

var hitbox_offset: Vector3 = Vector3(0, 0.3, 0)


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
		$HitBox/CollisionShape3D.position = owner.jump_marker.global_position


func attempt_jump():
	if owner.is_on_floor():
		if allow_air_jump:
			jump_count -= 1
		do_jump()
	else:
		if allow_air_jump and jump_count < max_jumps:
			owner.doing_unique_anim = true
			owner.anim_player.play("roll")
			do_jump()
			if owner.doing_unique_anim and !owner.is_on_floor():
				await owner.anim_player.animation_finished
				owner.doing_unique_anim = false


func do_jump():
	owner.velocity.y = 0
	jump_audio_node.play(0.0)
	jump_count += 1
	owner.velocity = owner.up_direction * (jump_power * jump_power_mod)


func do_bounce():
	emit_signal("bounced")
	owner.doing_unique_anim = true
	owner.anim_player.play("roll")
	jump_power_mod = max_jump_power_mod
	do_jump()
	if allow_air_jump:
			refresh_cooldown.emit()
	if owner.doing_unique_anim and !owner.is_on_floor():
		await owner.anim_player.animation_finished
		owner.doing_unique_anim = false


func refresh_jumps():
	jump_count = 0


func _on_hit_box_body_entered(body):
	if body.has_method("take_damage"):
		do_bounce()
		
		var new_attack = Attack.new()
		new_attack.attack_type = 0
		new_attack.attack_damage = damage
#		new_attack.knockback = bounce_strength
#		new_attack.attack_position = owner.global_position
		new_attack.attack_stun_time = stun_time
		body.take_damage(new_attack)
