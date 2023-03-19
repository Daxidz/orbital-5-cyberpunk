extends RigidBody2D


var selected: bool = false
var on_tapis: bool = true
var speed: float = 200.0

var ingr_name: String = ""

var end_pos_x: float

func set_texture(texture_name):
	var texture = load("res://res/img/ingredients/"+texture_name+".svg")
	$Sprite2D.texture = texture

func _ready():
	freeze = true
	set_physics_process(true)
	$AnimationPlayer.play("Float")

func _process(delta):
	if on_tapis:
		if global_position.x > end_pos_x:
			queue_free()
		global_position.x += delta * speed
		return
	
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 0.3)


func _input(event):
	if event.is_action_released("click") and selected:
		selected = false
		set_physics_process(true)
		mass = 1.0
		linear_velocity = (get_global_mouse_position() - global_position) * 3
		freeze = false


func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event.is_action_pressed("click") and not selected:
		selected = true
		$AnimationPlayer.pause()
		freeze = true
		on_tapis = false

