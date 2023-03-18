extends Node2D

@onready var ingerdient = preload("res://src/ingr_test.tscn")

func _ready():
	$Mixer.connect("mixed", _on_mixed)
	pass

func _input(event):
	
	if event.is_action_pressed("spawn_debug"):
		var ingr = ingerdient.instantiate()
		ingr.global_position = get_global_mouse_position()
		add_child(ingr)

func _on_button_pressed():
	$Mixer.mix()
	
	
func _on_mixed(ingerdients_mixed: Array):
	print(ingerdients_mixed)
	
	if ingerdients_mixed.size() != 0:
		for i in ingerdients_mixed:
			i.queue_free()
	
	
