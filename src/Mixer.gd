extends Node2D

var bodies_in_mixer = []

signal mixed(ingerdients_mixed)

func _on_mix_area_body_entered(body):
	if body.is_in_group("ingr"):
		print(str(body) + " ENTER")
		body.modulate = Color(1,1,1,0.5)
		bodies_in_mixer.push_back(body)

func _on_mix_area_body_exited(body):
	if body.is_in_group("ingr"):
		if bodies_in_mixer.find(body) != -1:
			print(str(body) + " EXIT")
			body.modulate = Color(1,1,1,1)
			bodies_in_mixer.erase(body)

func mix():
	var ingredients_names = []
	
	if bodies_in_mixer.size() == 0:
		return
	for b in bodies_in_mixer:
		ingredients_names.push_back(b.ingr_name)
	emit_signal("mixed", ingredients_names)
	
	if !$Mix.is_playing():
		$Mix.play()
	
	for b in bodies_in_mixer:
		b.queue_free()
		
	bodies_in_mixer.clear()


func _on_bord_body_entered(body):
	if body.is_in_group("ingr"):
		var pitch = randf_range(0.7, 1.4)
		$Collision.pitch_scale = pitch
		$Collision.play()
