extends Area3D

@export var target_cell_distance: Vector3

var is_active: bool = false
var is_in_foreground: bool = false

var player_ref: CharacterBody3D

var grid_map_ref: GridMap

var target_pos: Vector3
var target_x_pos: float
var target_y_pos: float
var target_z_pos: float


func _ready():
	player_ref = get_tree().get_first_node_in_group("player")
	set_physics_process(false)
	
	if get_parent():
		grid_map_ref = get_parent()
	match is_in_foreground:
		true:
			$FrontRayCast.queue_free()
		false:
			$BackRayCast.queue_free()


func move_player_forward():
	if !is_in_foreground:
		#send forward
		if !$FrontRayCast.get_collider():
			player_ref.travel_layer("forward")
			target_pos.x = player_ref.position.x + (target_cell_distance.x * grid_map_ref.cell_size.x)
			target_pos.y = player_ref.position.y + (target_cell_distance.y * grid_map_ref.cell_size.y)
			target_pos.z = player_ref.position.z + (target_cell_distance.z * grid_map_ref.cell_size.z)
			await player_ref.change_layer
			
			var new_tween = create_tween()
			new_tween.tween_property(player_ref, "position", target_pos, 0.2)
			await new_tween.finished
			print("tween finished")
	
	
func move_player_backward():
	if is_in_foreground:
		#send backward
		if !$BackRayCast.get_collider():
			player_ref.state_machine.current_state.Transitioned.emit(player_ref.state_machine.current_state, "Busy")
			player_ref.travel_layer("backward")
			target_pos.x = player_ref.position.x + (target_cell_distance.x * grid_map_ref.cell_size.x)
			target_pos.y = player_ref.position.y + (target_cell_distance.y * grid_map_ref.cell_size.y)
			target_pos.z = player_ref.position.z - (target_cell_distance.z * grid_map_ref.cell_size.z)
			await player_ref.change_layer
			
			var new_tween = create_tween()
			new_tween.tween_property(player_ref, "position", target_pos, 0.2)
			await new_tween.finished
			print("tween finished")
			player_ref.state_machine.current_state.Transitioned.emit(player_ref.state_machine.current_state, "Idle")


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref.up_pressed.connect(move_player_backward)
		player_ref.down_pressed.connect(move_player_forward)
		is_active = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.disconnect("up_pressed", move_player_backward)
		body.disconnect("down_pressed", move_player_forward)
		is_active = false
