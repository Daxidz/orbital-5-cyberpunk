class_name RecipePanel extends Node2D

@onready var Ingredients: Array = [
	$Background/Ingredient1,
	$Background/Ingredient2, 
	$Background/Ingredient3
]
@onready var TimerBar: TextureProgressBar = $Background/TimerBar
