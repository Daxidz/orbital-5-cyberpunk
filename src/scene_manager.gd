extends Node2D

@onready var main_scene = preload("res://src/main.tscn")

var state: = 0




func _ready():
	state = 0
	$Menu.play_clicked.connect(_on_play_pressed)
	$Menu.tuto_clicked.connect(_on_tuto_pressed)
	$Menu.credits_clicked.connect(_on_credits_pressed)
	$Menu.quit_clicked.connect(_on_quit_pressed)
	
	
func _input(event):
	if event.is_action_pressed("click"):
		if state == 1:
			state = 1
			$Menu.visible = false
			$AnimationPlayer.play("fade_in")
		elif state == 7 or state == 8:
			state = 10
			$AnimationPlayer.play("fade_in")



func _on_play_pressed():
	state = 0
	$AnimationPlayer.play("fade_in")


func _on_tuto_pressed():
	
	$AnimationPlayer.play("fade_in")
	state = 7

func _on_credits_pressed():
	$AnimationPlayer.play("fade_in")
	state = 8


func _on_quit_pressed():
	get_tree().quit()

var main_scene_tmp

func _on_animation_player_animation_finished(anim_name):
	
	if (anim_name == "fade_in"):
		if state == 1:
			state = 2
			print("Launching game")
#			$Menu.show_tuto(false)
			$Menu.visible = false
			$Tuto.visible = false
			main_scene_tmp = main_scene.instantiate()
			main_scene_tmp.game_over.connect(_on_Game_over)
			add_child(main_scene_tmp)
			$AnimationPlayer.play("fade_out")
			
		elif state == 10:
			$Tuto.visible = false
			$DeathScreen.visible = false
			$Credits.visible = false
			state = 0
			$AnimationPlayer.play("fade_out")
			
		elif state == 0:
#			$Menu.show_tuto(true)
			$Tuto.visible = true
			$DeathScreen.visible = false
			$Credits.visible = false
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
			state = 10
			
		elif state == 7:
			$Tuto.visible = true
			$AnimationPlayer.play("fade_out")
			
		elif state == 8:
			$Credits.visible = true
			$AnimationPlayer.play("fade_out")
			
		

func _on_Game_over():
	$AnimationPlayer.play("fade_in")


func _on_return_menu_button_pressed():
	$AnimationPlayer.play("fade_in")
