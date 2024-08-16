extends Node2D

const PERSON = preload("res://scenes/person.tscn")

var current_person:PersonNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.add_child(PERSON.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_good_button_button_down() -> void:
    GlobalSignals.next_person.emit()


func _on_bad_button_button_down() -> void:
    GlobalSignals.next_person.emit()
