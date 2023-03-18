extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(2, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
