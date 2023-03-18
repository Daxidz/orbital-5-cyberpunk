class_name RecipesManager extends Node

@export var SPAWN_INTERVAL_MIN: float = 3
@export var SPAWN_INTERVAL_MAX: float = 6

@export var TIMER_INTERVAL: float = 0.5

var RECIPES: Array = [
	Recipe.new(["essence", "pile"]),
	Recipe.new(["boulon", "brocoli"]),
]
var ongoing_recipes: Array

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var next_spawn_tick: float = 0
var timer_tick: float = 0

var RecipePanelInstancier = preload("res://src/recipe_panel.tscn")

@onready var timer: Timer = $Timer

func _ready():
	ongoing_recipes = RECIPES
	timer.start(TIMER_INTERVAL)
	
	var recipe_panel1 = RecipePanelInstancier.instantiate()
	var recipe_panel2 = RecipePanelInstancier.instantiate()
	
	# var recipes_list = get_tree().get_root().get_node("Main/UI/Recipes/RecipesVerticalList")
	var screen = get_tree().get_root().get_node("Main/Ecran") as Sprite2D
	print_debug("screen.position.x: %f, y: %f" % [screen.position.x, screen.position.y])

#	if (screen != null):
#		screen.add_child(recipe_panel1)
#		screen.add_child(recipe_panel2)

func generate_next_spawn():
	self.next_spawn_tick = self.timer_tick + self.rng.randf_range(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX)
	print_debug("next_spawn_tick: %f" % self.next_spawn_tick)

func spawn_new_recipe():
	var recipe: Recipe = RECIPES[self.rng.randi_range(0, RECIPES.size() - 1)]
	self.ongoing_recipes.append(recipe)

	print_debug("Added new recipe: %s" % recipe)

	self.generate_next_spawn()

func _on_timer_timeout():
	self.timer_tick += 1
	if (self.timer_tick >= self.next_spawn_tick):
		self.spawn_new_recipe()

func is_ongoing_recipe_valid(ingredients: Array):
	ingredients.sort()
	
	var same = self.ongoing_recipes.filter(func(recipe): return recipe.ingredients == ingredients)
	if (same.size() > 0):
		for recipe in self.ongoing_recipes:
			if (recipe.ingredients == ingredients):
				self.ongoing_recipes.erase(recipe)
	
	return (same.size() > 0)


class Recipe:
	var ingredients: Array

	func _init(ingredients: Array):
		self.ingredients.append_array(ingredients)
		self.ingredients.sort()

	func _to_string():
		var result = "[ "
		for ingredient in self.ingredients:
			result += "%s " % ingredient
		result += "]"

		return result
