extends Node3D

@onready var front_layer_grid = $FrontLayer/GridMap
@onready var rear_layer_grid = $BackLayer/GridMap


func _ready():
	var layer_doors_cells = front_layer_grid.get_used_cells_by_item(3)
	for i in layer_doors_cells:
		var new_door = load("res://environments/portals/layer_door.tscn").instantiate()
		new_door.position = i * Vector3i(front_layer_grid.cell_size)
		new_door.position += front_layer_grid.cell_size * 0.5
		new_door.is_in_foreground = true
		front_layer_grid.add_child(new_door)
		front_layer_grid.set_cell_item(i, -1)
	
	layer_doors_cells = rear_layer_grid.get_used_cells_by_item(3)
	for i in layer_doors_cells:
		var new_door = load("res://environments/portals/layer_door.tscn").instantiate()
		new_door.position = i * Vector3i(front_layer_grid.cell_size)
		new_door.position += rear_layer_grid.cell_size * 0.5
		new_door.is_in_foreground = false
		front_layer_grid.add_child(new_door)
		rear_layer_grid.set_cell_item(i, -1)


func _input(event):
	if Input.is_action_just_pressed("restart"):
		await get_tree().process_frame
		get_tree().reload_current_scene()
