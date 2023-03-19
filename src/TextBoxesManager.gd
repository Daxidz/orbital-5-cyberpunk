extends Node2D

@onready var TextBox = preload("res://src/textbox.tscn")


var TEXTS = [
	"Bordel! Tu fais quoi?",
	"Non mais Allo?!",
	"F%CK",
	"PUTAIN!!",
	"What the f@ck?!",
	"You’re the reason God created the AI ",
	"I’m not insulting you, I’m describing you.",
	"I’m not a nerd. I’m just smarter than you.",
	"Tu es aussi vif qu'un robot aspirateur.",
	"Were you born this stupid or did you take lessons?",
	"Someday you’ll go far. And I really hope you stay there.",
	"Oops, my bad. I could’ve sworn I was dealing with an AI.",
	"Keep rolling your eyes, you might eventually find a brain.",
	"I wish I was a flip phone, so I could slam it shut on this conversation.",
	"Wow, your maker really didn’t waste time giving you a personality, huh?"
]

var ROBOTVOICE_LONG = [
	"Robot01.wav",
	"Robot03.wav",
]

var ROBOTVOICE = [
	"Robot02.wav",
	"Robot04.wav",
	"Robot05.wav"
]
var time_between_spawn: float = 3

func _ready():
	$Timer.start(time_between_spawn)

func _on_timer_timeout():
	var tb = TextBox.instantiate()
	
	tb.position = Vector2(randf_range(200, 1700), randf_range(100, 900))
	var textAI = TEXTS.pick_random()
	tb.text = textAI
	add_child(tb)
	var char = textAI.length()
	print(char)
	if char > 42:
		$Robot.stream = load("res://res/sounds/"+ROBOTVOICE_LONG.pick_random())
	else:
		$Robot.stream = load("res://res/sounds/"+ROBOTVOICE.pick_random())
	$Robot.play()
	$Popup.play()
	$Timer.start(time_between_spawn)
