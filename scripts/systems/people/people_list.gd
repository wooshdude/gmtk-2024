extends Resource
class_name PeopleList

@export var people:Array[Person]

func get_next_person() -> Person:
	var next_person = people.pop_at(0)
	return next_person
