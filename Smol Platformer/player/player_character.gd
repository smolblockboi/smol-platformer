extends CharacterBody3D

signal up_pressed
signal down_pressed

signal change_layer

@export var level_ref: Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var current_jump_ability_ref: Node = $CurrentJumpAbility
@onready var current_mobility_ability_ref: Node = $CurrentMobilityAbility
@onready var current_attack_ability_ref: Node = $CurrentAttackAbility

@onready var body_sprite: Sprite3D = $Sprite3D
@onready var grab_marker: Marker3D = $GrabMarker
@onready var jump_marker = $JumpMarker

@onready var state_machine: StateMachine = $StateMachine

var is_busy: bool = false
var doing_unique_anim: bool = false

var facing_right: bool = true


func _physics_process(delta):
	if Input.is_action_just_pressed("rotate_gravity"):
		match up_direction:
			Vector3.UP:
				up_direction = Vector3.RIGHT
			Vector3.RIGHT:
				up_direction = Vector3.DOWN
			Vector3.DOWN:
				up_direction = Vector3.LEFT
			Vector3.LEFT:
				up_direction = Vector3.UP
	
	facing_right = !$Sprite3D.is_flipped_h()
	
	if !state_machine.current_state.name == "Busy":
		if is_on_floor():
			if Input.is_action_just_pressed("move_up"):
				emit_signal("up_pressed")
			if Input.is_action_just_pressed("move_down"):
				emit_signal("down_pressed")
		
		match up_direction:
			Vector3.UP: # normal
				if velocity.x > 0:
					$Sprite3D.flip_h = false
				if velocity.x < 0:
					$Sprite3D.flip_h = true
			Vector3.DOWN: # upside down
				if velocity.x < 0:
					$Sprite3D.flip_h = false
				if velocity.x > 0:
					$Sprite3D.flip_h = true
			Vector3.LEFT: # fall right
				if velocity.y > 0:
					$Sprite3D.flip_h = false
				if velocity.y < 0:
					$Sprite3D.flip_h = true
			Vector3.RIGHT: # fall left
				if velocity.y < 0:
					$Sprite3D.flip_h = false
				if velocity.y > 0:
					$Sprite3D.flip_h = true
		
	is_busy = state_machine.current_state.name == "Busy"
		
	move_and_slide()


func travel_layer(direction_string: String):
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "Busy")
	
	match direction_string:
		"forward":
			if level_ref:
				reparent(level_ref.front_layer_grid, true)
			anim_player.play("layer_jump_forward")
		"backward":
			if level_ref:
				reparent(level_ref.rear_layer_grid, true)
			anim_player.play("layer_jump_backward")
	await anim_player.animation_finished
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "Idle")


func attempt_change_layer():
	change_layer.emit()


func walked_into():
	print("ouch")
