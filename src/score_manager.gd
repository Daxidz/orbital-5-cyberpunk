class_name ScoreManager extends Node2D

signal recipe_completed
signal recipe_timed_out

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.recipe_completed.connect(self._recipe_completed)
	self.recipe_timed_out.connect(self._recipe_timed_out)
	$Label.text = "%d" % score

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (score != 0):
		$Label.text = "%+d" % score
	else:
		$Label.text = "%d" % score

func _recipe_completed():
	print_debug("_recipe_completed()")
	self.score += 1
	
func _recipe_timed_out():
	print_debug("_recipe_timed_out()")
	self.score -= 1
