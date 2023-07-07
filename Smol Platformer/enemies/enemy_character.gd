extends CharacterBody3D
class_name Enemy

signal change_layer

@export var max_health: int = 2
var current_health: int = max_health

@export var dropped_ability: PackedScene

@export var state_machine: StateMachine

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var current_jump_ability_ref: Node = $CurrentJumpAbility
@onready var current_mobility_ability_ref: Node = $CurrentMobilityAbility
@onready var current_attack_ability_ref: Node = $CurrentAttackAbility

@onready var body_sprite: Sprite3D = $Sprite3D

@onready var collision_shape_node: CollisionShape3D = $CollisionShape3D

var move_speed: float = 5.0
var jump_power: float = 8.5
var fall_speed: float = -0.5

var can_sprite_flip: bool = true
var doing_unique_anim: bool = false

var facing_right: bool = true

var stun_count: float = 0.0


func _physics_process(delta):
	facing_right = !$Sprite3D.is_flipped_h()
	
	if can_sprite_flip:
		sprite_face_dir()
		
	await get_tree().physics_frame
	
	move_and_slide()


func sprite_face_dir():
	if velocity.x > 0:
		$Sprite3D.flip_h = false
	if velocity.x < 0:
		$Sprite3D.flip_h = true


func travel_layer(direction_string: String):
	can_sprite_flip = false
	match direction_string:
		"forward":
			anim_player.play("layer_jump_forward")
		"backward":
			anim_player.play("layer_jump_backward")
	await anim_player.animation_finished
	can_sprite_flip = true


func attempt_change_layer():
	emit_signal("change_layer")


func get_grabbed():
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "grabbed")


func be_thrown(throw: Throw):
	throw.print_damage()
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")
	
	state_machine.current_state.thrown_strength = throw.throw_knockback
	state_machine.current_state.origin = throw.throw_orgin
	state_machine.current_state.air_time = throw.throw_stun_time


func take_damage(attack: Attack):
	attack.print_damage()
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "stunned")
	
	state_machine.current_state.stun_knockback = attack.knockback
	state_machine.current_state.impact_dir = attack.attack_position
	state_machine.current_state.stun_time = attack.attack_stun_time
	state_machine.current_state.knockback_time = attack.attack_stun_time * 0.25
	
	current_health -= attack.attack_damage
	if current_health <= 0:
		if dropped_ability:
			await drop_ability()
			queue_free()
		else:
			await get_tree().physics_frame
			queue_free()


func drop_ability():
	var dropped_pickup = load("res://abilities/pickups/ability_pickup.tscn").instantiate()
	var enemy_ability = dropped_ability.instantiate()
	print(enemy_ability.type)
	print(dropped_pickup.power_type)
	
	dropped_pickup.power_type = enemy_ability.type
	dropped_pickup.power_pickup = enemy_ability
	
	get_parent().add_child(dropped_pickup)
	dropped_pickup.global_position = global_position


func take_dash_damage():
	print("bonked!")
	queue_free()


func take_jump_damage():
	print("stomped!")
	queue_free()
