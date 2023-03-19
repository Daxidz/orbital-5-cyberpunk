extends Node2D

signal ingredient_threshold
signal ingredient_spawned

const NAMES = ["ampoule", "boulon", "brocoli", "essence", "pile", "butterfly"]

@onready var Ingredient = preload("res://src/Ingredient.tscn")

@export var spawn_interval_base: float = 2.0
var spawn_interval: float = spawn_interval_base

@export var speed_base: float = 200
var speed_current: float = speed_base

var nb_ingredients_total: int = 0

@export var ingredients_history_depth: int = 8
var ingredients_history: Array = []

@onready var recipesManager: RecipesManager = get_tree().get_root().get_node("Main/RecipesManager")

func _ready():
	spawn_interval = spawn_interval_base
	$Timer.start(spawn_interval)

func _process(delta):
	$ParallaxBackground.scroll_offset.x += delta*50
	
func add_ingredient_to_history(name: String):
	self.ingredients_history.push_front(name)
	while (self.ingredients_history.size() > self.ingredients_history_depth):
		self.ingredients_history.pop_back()

func spawn_ingredient():
	emit_signal("ingredient_spawned")
	if nb_ingredients_total % 10 == 0:
		emit_signal("ingredient_threshold")
	var ingr = Ingredient.instantiate()
	ingr.position.x = $SpawnPosDown.position.x
	ingr.position.y = randf_range($SpawnPosDown.position.y, $SpawnPosUp.position.y)
	ingr.speed = speed_current
	
	var current_ingredients: Array = [] 
	if (nb_ingredients_total > 10):
		for recipe in recipesManager.ongoing_recipes:
			current_ingredients.append_array(recipe.ingredients)
		for ingredient in current_ingredients:
			if (self.ingredients_history.find(ingredient) == -1):
				ingr.ingr_name = ingredient
	
	if (ingr.ingr_name == ""):
		ingr.ingr_name = NAMES.pick_random()
	
		if (self.ingredients_history.find(ingr.ingr_name) != -1):
			ingr.ingr_name = NAMES.pick_random()

	add_ingredient_to_history(ingr.ingr_name)
	
	ingr.set_texture(ingr.ingr_name)
	ingr.end_pos_x = $EndPos.global_position.x
	get_parent().add_child(ingr)
	nb_ingredients_total += 1

func _on_timer_timeout():
	spawn_ingredient()
	spawn_interval = randf_range(0.6, 1.0)
	$Timer.start(spawn_interval)
	
