extends Node2D


@onready var Ingredient = preload("res://src/Ingredient.tscn")

@export var spawn_interval_base: float = 2.0
var spawn_interval: float = spawn_interval_base

func _ready():
	spawn_interval = spawn_interval_base
	$Timer.start(spawn_interval)

func _process(delta):
	$ParallaxBackground.scroll_offset.x += delta*50

func _on_timer_timeout():
	var ingr = Ingredient.instantiate()
	ingr.position.y = randf_range($SpawnPosDown.position.y, $SpawnPosUp.position.y)
	ingr.position.x = randf_range(200, 1700)
	
	get_parent().add_child(ingr)
	spawn_interval -= spawn_interval/30
	$Timer.start(spawn_interval)
	
