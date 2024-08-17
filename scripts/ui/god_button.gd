extends HBoxContainer
class_name GodButton

signal hovered(GodButton)
signal clicked(GodButton)

var mouse_inside:bool


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if mouse_inside:
			clicked.emit(self)


func _on_mouse_entered():
	mouse_inside = true
	hovered.emit(self)


func _on_mouse_exited():
	mouse_inside = false
