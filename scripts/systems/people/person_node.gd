extends Node2D
class_name PersonNode
@onready var person_texture: AnimatedSprite2D = $PersonTexture
@onready var dialogue: Control = $CanvasLayer/Dialogue

var elasped:float = 0
var xray:Node2D

@export var person_data:Person :
	set(value):
		print("new data %s" % value)
		person_data = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.dismiss.connect(_on_dismissed)
	GlobalSignals.damn.connect(_on_damned)
	person_texture.play("default")
	position = Vector2(-64, get_viewport_rect().size.y /2)
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x /2, position.y), 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	new_tween.finished.connect(_on_tween_finished)
	await new_tween.finished
	dialogue.start(person_data.dialogue)
	if person_data.memos.size() > 0:
		for memo in person_data.memos:
			GlobalSignals.memo_created.emit(memo)
	if person_data.regulation:
		GlobalSignals.notification.emit("A new regulation has appeared!")
		GlobalSignals.regulation.emit(person_data.regulation)


func display_items():
	if person_data.trade != Person.Trade.NONE:
		for i in range(3):
			var new_item = create_draggable()
			new_item.type = Draggable.ItemType.BELONGING
			new_item.texture = load("res://assets/sprites/belongings/pick_up_" + str(person_data.Texture_Ref[person_data.trade][i]) + ".png")
			add_child(new_item)
	
	var new_heart = create_draggable()
	new_heart.texture = load("res://assets/sprites/animated_heart/animated_heart.tres")
	new_heart.type = Draggable.ItemType.HEART
	new_heart.weight = person_data.weight
	new_heart.rotation = 0
	add_child(new_heart)
		

func create_draggable() -> Draggable:
	var new_item = Draggable.new()
	new_item.top_level = true
	new_item.texture = load("res://icon.svg")
	new_item.position = Vector2(
		randf_range(215,310),
		randf_range(120,190)
	)
	new_item.rotation_degrees = randf_range(0,359)
	new_item.z_as_relative = false
	new_item.z_index = 2
	return new_item


func _on_damned():
	self.person_texture.play("attacked")
	await person_texture.animation_finished
	_on_person_left()

func _on_dismissed():
	
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(get_viewport_rect().size.x + 64, position.y), 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	new_tween.finished.connect(_on_person_left)


func _on_tween_finished():
	await get_tree().physics_frame
	if person_data:
		print("person %s" % person_data)
		print("weight: %s" % person_data.weight)
		print("constellation: %s" % person_data.constellation)
		print("trade: %s" % person_data.trade)
	display_items()
	GlobalSignals.person_ready.emit()
	

func _on_person_left():
	GlobalSignals.next_person.emit()
	self.queue_free()


func _on_button_pressed() -> void:
	if not dialogue.playing and not dialogue.visible:
		print('restarting dialogue')
		dialogue.start(person_data.dialogue)
	if not dialogue.playing and dialogue.visible:
		dialogue.visible = false
