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

var next_spawn_tick: float = 5
var timer_tick: float = 0

var RecipePanelInstancier = preload("res://src/recipe_panel.tscn")

@onready var timer: Timer = $Timer

func _ready():
	self.redraw_recipes()
	timer.start(TIMER_INTERVAL)

var recipes_panels: Array = []

func redraw_recipes():
	var main = get_tree().get_root().get_node("Main")
	var screen = main.get_node("Ecran") as Sprite2D
	
	var x = screen.position.x - 290
	var y = screen.position.y + 20
	
	for panel in self.recipes_panels:
		(panel as Node2D).hide()
		main.remove_child(panel)
		panel.queue_free()
	self.recipes_panels.clear()
	
	var i = 0
	for recipe in ongoing_recipes:
		var panel = RecipePanelInstancier.instantiate() as Node2D
		panel.position.x = x
		panel.position.y = y + ((80 + 10) * i)
		main.add_child(panel)
		self.recipes_panels.push_back(panel)
		i += 1

func generate_next_spawn():
	self.next_spawn_tick = self.timer_tick + self.rng.randf_range(SPAWN_INTERVAL_MIN, SPAWN_INTERVAL_MAX)

func spawn_new_recipe():
	var recipe: Recipe = RECIPES[self.rng.randi_range(0, RECIPES.size() - 1)]
	self.ongoing_recipes.append(recipe.duplicate())

	print_debug("Added new recipe: %s" % recipe)

	self.redraw_recipes()
	self.generate_next_spawn()

func _on_timer_timeout():
	self.timer_tick += 1
	if (self.timer_tick >= self.next_spawn_tick):
		self.spawn_new_recipe()

func is_ongoing_recipe_valid(ingredients: Array):
	ingredients.sort()
	
	self.ongoing_recipes.clear()
	self.redraw_recipes()
	
#	var same = self.ongoing_recipes.filter(func(recipe): return recipe.ingredients == ingredients)
#	if (same.size() > 0):
#		for recipe in self.ongoing_recipes:
#			if (recipe.ingredients == ingredients):
#				self.ongoing_recipes.erase(recipe)
#	return (same.size() > 0)
	return true


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
		
	func duplicate():
		return Recipe.new(ingredients.duplicate())
