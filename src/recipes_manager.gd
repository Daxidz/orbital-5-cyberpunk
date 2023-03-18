class_name RecipesManager extends Node

@export var SPAWN_INTERVAL_MIN: float = 3
@export var SPAWN_INTERVAL_MAX: float = 6

@export var TIMER_INTERVAL: float = 0.5

var RECIPES: Array = [
	Recipe.new(["Eau", "Get"]),
	Recipe.new(["Vodka", "Rhum"]),
]
var ongoing_recipes: Array

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var next_spawn_tick: float = 0
var timer_tick: float = 0

# @onready var IngredientInstancier = preload("res://src/ingredient.tscn")
@onready var timer: Timer = $Timer

func _ready():
	timer.start(TIMER_INTERVAL)

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
	var same = self.ongoing_recipes.filter(func(recipe): return recipe.ingredients == ingredients)
	print_debug("is_ongoing_recipe_valid() - same.size(): %d" % same.size())


class Recipe:
	var ingredients: Array

#	func equals(other: Recipe) -> bool:
#		return self.ingredients == other.ingredients

	func _init(ingredients: Array):
		self.ingredients.append_array(ingredients)

	func _to_string():
		var result = "[ "
		for ingredient in self.ingredients:
			result += "%s " % ingredient
		result += "]"

		return result
