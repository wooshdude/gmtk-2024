extends Resource
class_name RequestList

@export var list:Array[Request]

func get_next():
	return list.pop_at(0)
