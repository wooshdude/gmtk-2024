extends Control

@onready var book: Control = $MarginContainer/Book

@onready var tab_container: TabContainer = $Book/MarginContainer/TabContainer

var mouse_inside_book:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	book.position.y = get_viewport_rect().size.y
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and not mouse_inside_book:
		var new_tween = create_tween()
		new_tween.tween_property(book, "position", Vector2(book.position.x,get_viewport_rect().size.y), 0.2).set_trans(Tween.TRANS_SINE)
		await new_tween.finished
		#book.hide()
	


func _on_show_book_button_down() -> void:
	var new_tween = create_tween()
	#book.show()
	new_tween.tween_property(book, "position", Vector2(book.position.x,0), 0.2).set_trans(Tween.TRANS_SINE)
	


func _on_book_mouse_entered() -> void:
	mouse_inside_book = true


func _on_book_mouse_exited() -> void:
	mouse_inside_book = false
