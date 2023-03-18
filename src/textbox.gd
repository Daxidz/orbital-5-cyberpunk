extends Node2D

var text: String = "fiurhidrfjéi"

@onready var label: Label = $Label
@export var text_speed: float = 17

var text_size: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	label.text = text
	$ColorRect.size = label.size
	label.position = position + Vector2(40,20)
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
	tween.tween_property(self, "modulate", Color(1,1,1,0),0.2).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_Tween_finished)
	tween.play()
	
func _on_Tween_finished():
	queue_free()
	
