class_name ScoreManager extends Node2D

signal recipe_completed
signal recipe_timed_out
signal game_over

var lives: int = 3

@onready var hearts: Array = [
	$Heart3,
	$Heart2,
	$Heart1
]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.recipe_completed.connect(self._recipe_completed)
	self.recipe_timed_out.connect(self._recipe_timed_out)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(self.hearts.size()):
		var heart = self.hearts[i] as Sprite2D
		if (self.lives > i):
			heart.show()
		else:
			heart.hide()

func _recipe_completed():
	pass

func _recipe_timed_out():
	$Error.play()
	self.lives -= 1
	if (self.lives == 0):
		self.game_over.emit()
