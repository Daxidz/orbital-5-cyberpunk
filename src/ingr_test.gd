extends RigidBody2D


var selected: bool = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 0.5)




func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event.is_action_pressed("click") and not selected:
		selected = true
		set_physics_process(false)
		
	if event.is_action_released("click") and selected:
		selected = false
		set_physics_process(true)
		linear_velocity = Vector2.ZERO
