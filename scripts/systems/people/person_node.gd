extends Node2D
class_name PersonNode
@onready var person_texture: AnimatedSprite2D = $PersonTexture

var xray:Node2D

var person_data:Person :
	set(value):
		print("new data %s" % value)
		print(value.weight)
		person_data = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	person_texture.play("default")
	position = Vector2(-64, get_viewport_rect().size.y /2)
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x /2, position.y), 0.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	new_tween.finished.connect(_on_tween_finished)

	GlobalSignals.next_person.connect(_on_next_person)


func display_items():
	for i in range(person_data.belongings):
		var new_item = Draggable.new()
		new_item.top_level = true
		new_item.texture = load("res://icon.svg")
		new_item.position = Vector2(
			randf_range(200,350),
			randf_range(120,190)
		)
		new_item.rotation_degrees = randf_range(0,359)
		new_item.z_as_relative = false
		new_item.z_index = 2
		add_child(new_item)
		


func _on_next_person():
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x + 64, position.y), 0.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	new_tween.finished.connect(_on_person_left)


func _on_tween_finished():
	await get_tree().physics_frame
	if person_data:
		print("person %s" % person_data)
		print("weight: %s" % person_data.weight)
		print("wealth: %s" % person_data.wealth)
		print("constellation: %s" % person_data.constellation)
		print("trade: %s" % person_data.trade)
		print("belongings: %s" % person_data.belongings)
	display_items()
	

func _on_person_left():
	self.queue_free()
