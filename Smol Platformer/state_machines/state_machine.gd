extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func anim_handler():
	if !owner.doing_unique_anim:
		match current_state.name:
			"Idle", "Run", "Jump", "Patrol", "Follow":
				if owner.is_on_floor():
					if owner.velocity != Vector3.ZERO:
						owner.anim_player.play("run")
					else:
						owner.anim_player.play("idle")
				else:
					owner.anim_player.play("jump")
			"Stunned":
				if owner.is_on_floor():
					owner.anim_player.play("stunned")
				else:
					owner.anim_player.play("roll")
#			"Grab":
#				owner.anim_player.play("grab")
			"Grabbed":
				owner.anim_player.play("stunned")


func add_state(state: State):
	var new_state = state.instantiate()
	add_child(new_state)
	states[new_state.name.to_lower()] = new_state
	new_state.Transitioned.connect(on_state_transition)


func remove_state(state: State):
	states.erase(state)


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_state_transition)
	
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.process_state(delta)
		anim_handler()
#		if owner.is_in_group("player"):
#			print(current_state.name)


func _physics_process(delta):
	if current_state:
		current_state.physics_process_state(delta)


func on_state_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	
	current_state = new_state
