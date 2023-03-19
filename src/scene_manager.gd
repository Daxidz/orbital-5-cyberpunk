extends Node2D

@onready var main_scene = preload("res://src/main.tscn")

var state: = 0




func _ready():
	$Menu.play_clicked.connect(_on_play_pressed)
	$Menu.tuto_clicked.connect(_on_tuto_pressed)
	$Menu.credits_clicked.connect(_on_credits_pressed)
	$Menu.quit_clicked.connect(_on_quit_pressed)
	
	


func _input(event):
	if event.is_action_pressed("click") and state == 1:
		
		$AnimationPlayer.play("fade_in")

func _process(delta):
	pass


func _on_play_pressed():
	$AnimationPlayer.play("fade_in")


func _on_tuto_pressed():
	pass


func _on_credits_pressed():
	emit_signal("credits_clicked")


func _on_quit_pressed():
	emit_signal("quit_clicked")

var main_scene_tmp

func _on_animation_player_animation_finished(anim_name):
	
	if (anim_name == "fade_in"):
		if state == 1:
			$Menu.show_tuto(false)
			main_scene_tmp = main_scene.instantiate()
			main_scene_tmp.game_over.connect(_on_Game_over)
			add_child(main_scene_tmp)
			$AnimationPlayer.play("fade_out")
			state = 2
		elif state == 0:
			$Menu.show_tuto(true)
			$AnimationPlayer.play("fade_out")
			state = 1
		elif state == 2:
			main_scene_tmp.queue_free()
			$DeathScreen.visible = true
			$AnimationPlayer.play("fade_out")
			state = 3
			
		elif state == 3:
			$DeathScreen.visible = false
			$AnimationPlayer.play("fade_out")
			state = 0
			
			

func _on_Game_over():
	print("META GAME OVER")
	$AnimationPlayer.play("fade_in")


func _on_return_menu_button_pressed():
	$AnimationPlayer.play("fade_in")
