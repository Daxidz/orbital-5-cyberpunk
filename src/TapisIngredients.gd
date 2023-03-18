extends Node2D

const NAMES = ["ampoule", "boulon", "brocoli", "essence", "pile"]

@onready var Ingredient = preload("res://src/Ingredient.tscn")

@export var spawn_interval_base: float = 2.0
var spawn_interval: float = spawn_interval_base

@export var speed_base: float = 200
var speed_current: float = speed_base

var nb_ingredients_total: int = 0

func _ready():
	spawn_interval = spawn_interval_base
	$Timer.start(spawn_interval)

func _process(delta):
	$ParallaxBackground.scroll_offset.x += delta*50

func spawn_ingredient():
	if nb_ingredients_total % 10 == 0: 
		speed_current = speed_current * 1.1
	var ingr = Ingredient.instantiate()
	ingr.position.x = $SpawnPosDown.position.x
	ingr.position.y = randf_range($SpawnPosDown.position.y, $SpawnPosUp.position.y)
	ingr.speed = speed_current
	ingr.ingr_name = NAMES.pick_random()
	ingr.set_texture(ingr.ingr_name)
	ingr.end_pos_x = $EndPos.global_position.x
	get_parent().add_child(ingr)
	nb_ingredients_total += 1

func _on_timer_timeout():
	spawn_ingredient()
	spawn_interval = randf_range(0.5, 1.0)
	$Timer.start(spawn_interval)
	
