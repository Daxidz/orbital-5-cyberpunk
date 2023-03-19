extends Node2D


signal play_clicked
signal credits_clicked
signal quit_clicked
signal tuto_clicked

var something_displayed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _input(event):
#	if 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_tuto(show: bool):
	$Tuto.visible = show

func _on_play_pressed():
	emit_signal("play_clicked")


func _on_tuto_pressed():
	emit_signal("tuto_clicked")


func _on_credits_pressed():
	emit_signal("credits_clicked")


func _on_quit_pressed():
	emit_signal("quit_clicked")
