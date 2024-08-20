extends Node
# Grab Manager Singleton

var grabbed_object:Draggable
var confines:Sprite2D
var drop_z = 2
var grab_z = 4
var last_grab_z = 3
var stamp_z = 3
var heart:Draggable
var heart_radius = 20


var objects:Array[Draggable] = []

func check_can_drag(object:Draggable) -> bool:
	if object.disabled: return false
	for o in objects:
		if (o.grabbed or o.square_distance < object.square_distance) and o != object:
			return false
	return true

func on_heart(object:Draggable) -> bool:
	return (object.global_position - heart.global_position).length() < heart_radius
	

func get_confines_start():
	return confines.position - confines.scale * confines.texture.get_size()/2

func get_confines_end():
	return confines.position + confines.scale * confines.texture.get_size()/2

func get_confines_size():
	return confines.scale * confines.texture.get_size()


func add_object(object:Draggable):
	if object not in objects:
		objects.append(object)
	if object.type == Draggable.ItemType.HEART:
		heart = object

func remove_object(object:Draggable):
	objects.erase(object)
