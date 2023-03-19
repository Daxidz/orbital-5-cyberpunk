extends Node2D

var bodies_in_mixer = []

signal mixed(ingerdients_mixed)


var mixing: bool = false

var cur_ingredients = []

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
	if not mixing:
		mixing = true
		if bodies_in_mixer.size() == 0:
			
			mixing = false
			return
		for b in bodies_in_mixer:
			cur_ingredients.push_back(b.ingr_name)
			b.queue_free()
		$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
		$AnimatedSprite2D.play("mixing")
			
		bodies_in_mixer.clear()
		if !$Mix.is_playing():
			$Mix.play()
			$Timer.start(0.5)
			


func send_ingredients():
	var ingredients_names = []
	
	emit_signal("mixed", cur_ingredients)
	cur_ingredients.clear()
	


func _on_bord_body_entered(body):
	if body.is_in_group("ingr"):
		var pitch = randf_range(0.7, 1.4)
		$Collision.pitch_scale = pitch
		$Collision.play()

func end_mixing():
	mixing = false
	send_ingredients()
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.animation_finished.disconnect(_on_animated_sprite_2d_animation_finished)

func _on_animated_sprite_2d_animation_finished():
	if mixing:
		end_mixing()


func _on_timer_timeout():
	$Liquid.play()
	
func _on_texture_button_pressed():
	print("ihuewieurh")
	mix()
