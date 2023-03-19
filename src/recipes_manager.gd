class_name RecipesManager extends Node

@export var SPAWN_INTERVAL_MIN: float = 3		# seconds
@export var SPAWN_INTERVAL_MAX: float = 6		# seconds
@export var RECIPE_TIME_EXPIRATION: float = 10	# seconds
@export var TIMER_INTERVAL: float = 0.5			# seconds

var TIMER_TICKS_PER_SEC: float = 1 / TIMER_INTERVAL

var ampoule_texture = preload("res://res/img/ingredients/ampoule.svg")
var boulon_texture = preload("res://res/img/ingredients/boulon.svg")
var brocoli_texture = preload("res://res/img/ingredients/brocoli.svg")
var essence_texture = preload("res://res/img/ingredients/essence.svg")
var pile_texture = preload("res://res/img/ingredients/pile.svg")

var TEXTURES: Dictionary = {
	"ampoule": ampoule_texture,
	"boulon": boulon_texture,
	"brocoli": brocoli_texture,
	"essence": essence_texture,
	"pile": pile_texture
}

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

func _process(_delta):
	self.redraw_timers()

func redraw_timers():
	var now = Time.get_ticks_msec()
	var to_remove = []

	for i in range(self.recipes_panels.size()):
		var panel = self.recipes_panels[i] as Node2D
		var timer_bar = panel.get_child(0).get_child(3) as TextureProgressBar
		
		var elapsed = (now - self.ongoing_recipes[i].time) / 1000
		var progress = 100 - (elapsed / RECIPE_TIME_EXPIRATION) * 100
		timer_bar.set_value_no_signal(progress)
		if (progress >= 66):
			timer_bar.tint_progress = Color.GREEN
		elif (progress <= 33):
			timer_bar.tint_progress = Color.RED
		else:
			timer_bar.tint_progress = Color.ORANGE
		if (progress >= 0.1):
			timer_bar.queue_redraw()
		else:
			to_remove.push_back(i)
			
	for idx in to_remove:
		self.recipes_panels.remove_at(idx)
		self.ongoing_recipes.remove_at(idx)
		self.redraw_recipes()

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
		for j in range(recipe.ingredients.size()):
			var ingredient = recipe.ingredients[j]
			var sprite = panel.get_child(0).get_child(j) as Sprite2D
			sprite.set_texture(TEXTURES[ingredient])
			sprite.show()
		var timer_bar = panel.get_child(0).get_child(3) as TextureProgressBar
		timer_bar.set_value_no_signal(60)
		panel.position.x = x-69 # nice
		panel.position.y = y+10 + ((71 + 40) * i)
		main.add_child(panel)
		self.recipes_panels.push_back(panel)
		i += 1

func generate_next_spawn():
	self.next_spawn_tick = self.timer_tick + self.rng.randf_range(SPAWN_INTERVAL_MIN * TIMER_TICKS_PER_SEC, SPAWN_INTERVAL_MAX * TIMER_TICKS_PER_SEC)

func spawn_new_recipe():
	var recipe: Recipe = RECIPES[self.rng.randi_range(0, RECIPES.size() - 1)].duplicate()
	recipe.time = Time.get_ticks_msec()
	self.ongoing_recipes.append(recipe)

	self.redraw_recipes()
	self.generate_next_spawn()

func _on_timer_timeout():
	self.timer_tick += 1
	if (self.ongoing_recipes.size() >= 5):
		self.generate_next_spawn()
		pass
		
	if (self.timer_tick >= self.next_spawn_tick):
		self.spawn_new_recipe()

func is_ongoing_recipe_valid(ingredients: Array):
	ingredients.sort()
	
	var same = self.ongoing_recipes.filter(func(recipe): return recipe.ingredients == ingredients)
	if (same.size() > 0):
		for recipe in self.ongoing_recipes:
			if (recipe.ingredients == ingredients):
				self.ongoing_recipes.erase(recipe)
				break
				
	self.redraw_recipes()
	return (same.size() > 0)


class Recipe:
	var ingredients: Array
	var time: float

	func _init(ingredients: Array, time: float = Time.get_ticks_msec()):
		self.time = time
		self.ingredients.append_array(ingredients)
		self.ingredients.sort()

	func _to_string():
		var result = "[ "
		for ingredient in self.ingredients:
			result += "%s " % ingredient
		result += "]"

		return result
		
	func duplicate():
		return Recipe.new(self.ingredients.duplicate(), self.time)
