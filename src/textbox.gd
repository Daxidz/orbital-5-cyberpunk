extends Node2D

@export var text: String = "fiurhidrfjé ferf fer fer  erfeferferf ferferfer ergergf ei"

@onready var label: Label = $Label
@export var text_speed: float = 25

var text_size: int


func _ready():
	visible = false
	label.text = text
	label.visible_ratio = 1.0
	$ColorRect.set_size(label.size+ Vector2(100,60))
	label.visible_characters = 0
	text_size =label.get_total_character_count()
	visible = true
	$Timer.start(1.0/text_speed)

func _on_timer_timeout():
	label.visible_characters += 1
	
	if label.visible_characters == text_size:
		$DestroyTimer.start(1)
		return
	
	$Timer.start(1/text_speed)


func _on_destroy_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0),0.2)
	tween.finished.connect(_on_Tween_finished)
	tween.play()
	
func _on_Tween_finished():
	queue_free()
	
