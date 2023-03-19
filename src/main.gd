extends Node2D

@onready var ingerdient = preload("res://src/Ingredient.tscn")

var ingredient_speed_lvl: int = 0
var textbox_speed_lvl: int = 0

var nb_ingr_total: int = 0
var muted_bus = 0

func start():
	visible = true
	pass

func _ready():
	$Mixer.connect("mixed", _on_mixed)
	$TapisIngredients.ingredient_spawned.connect(_on_ingredient_spawned)
	$ScoreManager.game_over.connect(_on_death)

func _input(event):
	
	if event.is_action_pressed("spawn_debug"):
		var ingr = ingerdient.instantiate()
		ingr.global_position = get_global_mouse_position()
		add_child(ingr)

#func _on_button_pressed():
#	$Mixer.mix()
	
	
func spawn_glass():
	var idx = randi_range(3,6)
	var glass_tex = load("res://res/img/verres/glass"+str(idx)+".png")
	$GlassResult.texture = glass_tex
	var tween = create_tween()
	$CPUParticles2D.emitting = true
	tween.tween_property($GlassResult, "modulate", Color(0,0,0,0),0.0)
	tween.tween_property($GlassResult, "modulate", Color(1,1,1,1),1)
	tween.play()
	
	
func _on_mixed(ingredients_mixed: Array):
	var recipe_ok = $RecipesManager.is_ongoing_recipe_valid(ingredients_mixed)
	
	if recipe_ok:
		spawn_glass()
		print("Yay!!")
		$Yay.play()
	
func _on_ingredient_spawned():
	nb_ingr_total += 1
	
	if nb_ingr_total % 10 == 0:
		$TapisIngredients.speed_current *= 1.2
		
	if nb_ingr_total % 25 == 0:
		_level_increase()
	
	if nb_ingr_total % 5 == 0:
		print($TextBoxesManager.time_between_spawn)
		$TextBoxesManager.time_between_spawn -= 0.05
		if $TextBoxesManager.time_between_spawn < 0.0:
			$TextBoxesManager.time_between_spawn = 0
	
func _level_increase():
	muted_bus = muted_bus+1
	if muted_bus<4:
		AudioServer.set_bus_mute(muted_bus, false)


signal game_over

func _on_death():
	
	print(" GAME OVER")
	emit_signal("game_over")
	
