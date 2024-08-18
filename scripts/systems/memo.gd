extends draggable
class_name memo

@export var request_time : float = 10.0 # Adjusts the amount of time a request stays on screen

var rng = RandomNumberGenerator.new()


var gods = ["Joe", "Ballsack", "Osiris", "Saint-14", "Riven", "Savathun"] ##TODO change ENUMS to match player's enums
enum stats { WEIGHT, SIGN, BELONGINGS, TRADE, WEALTH }
enum signs { SOLAR, ARC, VOID, STASIS, STRAND }


var request
var request_completed = false



func _ready():
	super()
	self.type = objects.MEMO
	self.request = create_request("Joe", stats.TRADE , "Professional Baller")
	#TODO ADD SPAWN IN SFX
	request_timeout()
	print(request)
	
func _physics_process(delta: float) -> void:
	super(delta)
	display_request(self.request["text"])
	check_if_completed()
	if self.request_completed:
		delete_request()
	
	




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
	
func get_request():
	return self.request

func construct_string(god, stat, stat_value) -> String:       ## Change Dialogue as needed, this is just filler
	var str = ""                                              ## Dialogue is matched to the stat that has been requested
	str += god                                                ## Use the capitalized words in the match function as a reference
	str += " is looking for "
	match stat:
		stats.SIGN:
			str += "someone who is a " + str(stat_value) + "."
		stats.BELONGINGS:
			str += "someone who has " + str(stat_value) + " belongings."
		stats.WEIGHT:
			str += "someone who's heart weighs " + str(stat_value) + (" less " if stat_value < 0 else " more ") + "than a feather."
		stats.WEALTH:
			str += "someone who has " + str(stat_value) + " dollars." 
		stats.TRADE:
			str += "someone who worked as a " + str(stat_value) + "."
	return str

func display_request(text_to_display):
	pass
	# Dialogue plugin stuff goes here :) 


func request_timeout():
	get_tree().create_timer(request_time).timeout.connect(delete_request)

func check_if_completed():
	if self.request["fulfilled"]:
		request_completed = true

func delete_request():
	## TODO ADJUST SCORE
	print("Request deleted...")
	self.queue_free()
	
	
