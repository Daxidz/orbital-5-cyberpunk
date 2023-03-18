extends RigidBody2D


var selected: bool = false
var on_tapis: bool = true
var speed: float = 200.0


func _ready():
	set_physics_process(false)

func _process(delta):
	
	if on_tapis:
		global_position.x += delta * speed
		return
	
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 0.2)


func _input(event):
	if event.is_action_released("click") and selected:
		selected = false
		set_physics_process(true)
		linear_velocity = (get_global_mouse_position() - global_position) * 3


func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event.is_action_pressed("click") and not selected:
		selected = true
		set_physics_process(false)
		on_tapis = false
		
	
