extends Control

@onready var cursor: TextureRect = $Cursor
@onready var god_list: VBoxContainer = $VBoxContainer

var gods:Array[HBoxContainer] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.hide()
	cursor.position += Vector2(size.x - cursor.size.x, 0)
	for god:GodButton in god_list.get_children():
		gods.append(god)
		god.hovered.connect(_on_god_hovered)
		god.clicked.connect(_on_god_clicked)
	self.mouse_exited.connect(_on_mouse_exited)


func _on_god_clicked(button:GodButton):
	print(button.name)


func _on_god_hovered(button:GodButton):
	var new_tween := create_tween()
	if not cursor.visible:
		cursor.show()
		new_tween.tween_property(cursor, "modulate", Color(1,1,1,1), 0.1).set_trans(Tween.TRANS_SINE)
	new_tween.tween_property(cursor, "position", button.position + Vector2(size.x - cursor.size.x, 0), 0.1).set_trans(Tween.TRANS_SINE)


func _on_mouse_exited():
	var new_tween := create_tween()
	if cursor.visible:
		new_tween.tween_property(cursor, "modulate", Color(1,1,1,0), 0.1).set_trans(Tween.TRANS_SINE)
		await new_tween.finished
		cursor.hide()
