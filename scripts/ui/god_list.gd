extends Control

signal god_selected(string)

@onready var cursor: TextureRect = $Cursor
@onready var god_list: VBoxContainer = $VBoxContainer
@onready var memos: VBoxContainer = $ScrollContainer/Memos


var gods:Array[HBoxContainer] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.memo_created.connect(_on_memo_created)
	GlobalSignals.next_person.connect(_on_next_person)

	cursor.hide()
	cursor.position += Vector2(size.x - cursor.size.x, 0)
	for god:GodButton in god_list.get_children():
		gods.append(god)
	self.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_exited():
	var new_tween := create_tween()
	if cursor.visible:
		new_tween.tween_property(cursor, "modulate", Color(1,1,1,0), 0.1).set_trans(Tween.TRANS_SINE)
		await new_tween.finished
		cursor.hide()


func _on_memo_created(memo:Request):
	var new_label := Label.new()
	new_label.text = "%s\n- %s" % [memo.text, GodManager.get_god(memo.from).name]
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	GlobalSignals.notification.emit("New Memo from %s" % GodManager.get_god(memo.from).name)
	memos.add_child(new_label)

func _on_next_person():
	for child in memos.get_children():
		child.queue_free()
