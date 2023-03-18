extends Node2D

var bodies_in_mixer = []

signal mixed(ingerdients_mixed)

func _on_mix_area_body_entered(body):
	
	if body.is_in_group("ingr"):
		bodies_in_mixer.push_back(body)

func _on_mix_area_body_exited(body):
	if bodies_in_mixer.find(body):
		bodies_in_mixer.erase(body)

func mix():
	var ingredients_names = []
	for b in bodies_in_mixer:
		ingredients_names.push_back(b.ingr_name)
	emit_signal("mixed", ingredients_names)
	
	for b in bodies_in_mixer:
		b.queue_free()
		
	bodies_in_mixer.clear()