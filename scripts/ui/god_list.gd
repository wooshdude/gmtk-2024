extends Control

signal god_selected(string)


@onready var god_list: VBoxContainer = $VBoxContainer
@onready var memos: VBoxContainer = $ScrollContainer/Memos


var gods:Array[HBoxContainer] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.memo_created.connect(_on_memo_created)
	GlobalSignals.next_person.connect(_on_next_person)


func _on_memo_created(memo:Request):
	var new_label := Label.new()
	new_label.text = "%s\n- %s" % [memo.text, GodManager.get_god(memo.from).name]
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	GlobalSignals.notification.emit("New Memo from %s" % GodManager.get_god(memo.from).name)
	memos.add_child(new_label)

func _on_next_person():
	for child in memos.get_children():
		child.queue_free()
