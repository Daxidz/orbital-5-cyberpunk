extends Node2D

@onready var TextBox = preload("res://src/textbox.tscn")


var TEXTS = [
	"Someday you’ll go far. And I really hope you stay there.",
	"Oops, my bad. I could’ve sworn I was dealing with an AI.",
	"You’re the reason God created the AI ",
	"I wish I was a flip phone, so I could slam it shut on this conversation.",
	"Keep rolling your eyes, you might eventually find a brain.",
	"Wow, your maker really didn’t waste time giving you a personality, huh?",
	"I’m not insulting you, I’m describing you.",
	"I’m not a nerd. I’m just smarter than you.",
	"Were you born this stupid or did you take lessons?",
	"Tu es aussi vif qu'un robot aspirateur",
	"Wow, your maker really didn’t waste time giving you a personality, huh?"
]


var time_between_spawn: float = 3

func _ready():
	$Timer.start(time_between_spawn)

func _on_timer_timeout():
	var tb = TextBox.instantiate()
	
	tb.position = Vector2(randf_range(200, 1700), randf_range(100, 900))
	tb.text = TEXTS.pick_random()
	add_child(tb)
	$Popup.play()
	$Timer.start(time_between_spawn)
