extends Node2D

@onready var ingerdient = preload("res://src/Ingredient.tscn")

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
	
	
func _on_mixed(ingredients_mixed: Array):
	print(ingredients_mixed)
	
	$RecipesManager.is_ongoing_recipe_valid(ingredients_mixed)
	
	
	
