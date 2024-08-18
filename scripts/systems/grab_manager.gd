extends Node
# Grab Manager Singleton

var grabbed_object:Draggable

var objects:Array[Draggable] = []

func check_can_drag(object:Draggable) -> bool:
	for o in objects:
		if (o.grabbed or o.square_distance < object.square_distance) and o != object:
			return false
	return true

func add_object(object:Draggable):
	if object not in objects:
		objects.append(object)

func remove_object(object:Draggable):
	objects.erase(object)
