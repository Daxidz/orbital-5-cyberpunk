extends Node2D

@onready var TextBox = preload("res://src/textbox.tscn")

var time_between_spawn: float = 3

func _ready():
	$Timer.start(time_between_spawn)

func _on_timer_timeout():
	var tb = TextBox.instantiate()
	
	tb.position = Vector2(randf_range(200, 1700), randf_range(100, 900))
	tb.text = "iuzhdewiuh fekufiue fekfnejrfioo wedfce edfiewkjdf9erof "
	add_child(tb)
	
	$Timer.start(time_between_spawn)
