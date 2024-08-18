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

	GlobalSignals.dismiss.connect(_on_dismissed)


func display_items():
	for i in range(person_data.belongings):
		var new_item = create_draggable()
		new_item.type = Draggable.ItemType.BELONGING
		add_child(new_item)
	
	var new_heart = create_draggable()
	new_heart.texture = load("res://assets/sprites/heart1.png")
	new_heart.type = Draggable.ItemType.HEART
	add_child(new_heart)
		

func create_draggable() -> Draggable:
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
	return new_item


func _on_dismissed():
	self.person_texture.play("attacked")
	await person_texture.animation_finished
	
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
	GlobalSignals.next_person.emit()
	self.queue_free()
