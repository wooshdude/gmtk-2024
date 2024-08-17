extends Node2D
class_name PersonNode

var xray:Node2D

var person_data:Person :
	set(value):
		print("new data %s" % value)
		print(value.weight)
		person_data = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(-64, get_viewport_rect().size.y /2)
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x /2, position.y), 0.5).set_trans(Tween.TRANS_SINE)
	new_tween.finished.connect(_on_tween_finished)

	GlobalSignals.next_person.connect(_on_next_person)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GlobalSignals.next_person.emit()


func _on_next_person():
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x + 64, position.y), 0.5).set_trans(Tween.TRANS_SINE)
	new_tween.finished.connect(_on_person_left)


func _on_tween_finished():
	await get_tree().physics_frame
	print("person %s" % person_data)
	print("weight: %s" % person_data.weight)
	print("wealth: %s" % person_data.wealth)
	print("constellation: %s" % person_data.constellation)
	print("trade: %s" % person_data.trade)
	print("belongings: %s" % person_data.belongings)
	pass
	

func _on_person_left():
	self.queue_free()
