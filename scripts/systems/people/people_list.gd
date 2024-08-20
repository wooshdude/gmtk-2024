extends Resource
class_name PeopleList

@export var start:int
@export var people:Array[Person]
var debug:bool = false

func get_next_person() -> Person:
	if debug:
		debug = false
		people = people.slice(start, people.size()-1)
	var next_person = people.pop_at(0)
	if next_person:
		return next_person
	else:
		return null
