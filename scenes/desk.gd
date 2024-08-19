extends Node2D

const PERSON = preload("res://scenes/person.tscn")
@export var people_list:PeopleList
@export var xray:Node2D

var current_person:PersonNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.next_person.connect(_on_next_person)
	GlobalSignals.next_person.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_next_person():
	var new_person := PERSON.instantiate()
	var new_person_data := people_list.get_next_person()
	new_person.person_data = new_person_data
	new_person.xray = xray
	
	self.add_child(new_person)
	current_person = new_person


func _on_good_button_pressed() -> void:
	print('good')
	GlobalSignals.dismiss.emit()
	GodManager.receive_person(GodManager.Gods.OSIRIS, current_person.person_data)


func _on_mid_button_pressed() -> void:
	GlobalSignals.dismiss.emit()
	GodManager.receive_person(GodManager.Gods.ISIS, current_person.person_data)


func _on_bad_button_pressed() -> void:
	GlobalSignals.damn.emit()
	GodManager.receive_person(GodManager.Gods.SET, current_person.person_data)
