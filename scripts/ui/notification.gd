extends Label
class_name Notification

@export var lifetime:float = 10
var timer:SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_tree().create_timer(lifetime)
	#timer.start(lifetime)
	timer.timeout.connect(_on_timer_timeout)
	self.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT


func _on_timer_timeout():
	var new_tween := create_tween()
	new_tween.tween_property(self, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_OUT)
	await new_tween.finished
	queue_free()
