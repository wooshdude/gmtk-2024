extends Node
# God Relationship Singleton

signal person_received(Person)

const MEMO = preload("res://scenes/memo.tscn")

enum Need {
	ZODIAC,
	TRADE,
	PURITY,
	WEALTH
}

static var RA = "Ra"
static var ORISIS = "Orisis"
static var SAVATHUN = "Savathun"

class God:
	var name:String
	var relationship:int
	var current_task:Task


class Task:
	var num_people:int
	var current_need:Need


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		var new_request = create_request(RA, Need.ZODIAC, Person.Constellation.ARIES)
		var new_memo = MEMO.instantiate()
		add_child(new_memo)
		new_memo.request = new_request 


func create_request(god_choice, stat_choice, stat_value_choice) -> Dictionary:
	var god = god_choice                            ##TODO assign each variable with a value randomly (not sure how you wanted this Park, 
	var stat = stat_choice                          ## but i figured you'd want to assign them outside of the memo itself, and then pass them to the memo)
	var stat_value = stat_value_choice
	
	var request = {
		"god" : god,
		"stat" : stat,
		"stat_value" : stat_value,
		"text" : construct_string(god, stat, stat_value),
		"fulfilled" : false
	}
	return request


func construct_string(god, stat:Need, stat_value) -> String:       ## Change Dialogue as needed, this is just filler
	var str = ""                                              ## Dialogue is matched to the stat that has been requested
	str += god                                                ## Use the capitalized words in the match function as a reference
	str += " is looking for "
	match stat:
		Need.ZODIAC:
			str += "someone who is a " + str(stat_value) + "."
		Need.TRADE:
			str += "someone who has " + str(stat_value) + " belongings."
		Need.PURITY:
			str += "someone who's heart weighs " + str(stat_value) + (" less " if stat_value < 0 else " more ") + "than a feather."
		Need.WEALTH:
			str += "someone who has " + str(stat_value) + " dollars." 
	return str


func receive_person(_god:Gods, person:Person):
	person_received.emit(person)
