extends Control
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.memo_created.connect(_on_memo_created)


func _on_memo_created(memo:Request):
	var new_label = Label.new()
	new_label.text = memo.construct_string()
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	v_box_container.add_child(new_label)
