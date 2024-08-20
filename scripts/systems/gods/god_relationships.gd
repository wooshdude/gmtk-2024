extends Node
# God Relationship Singleton

signal person_received(Person)
const REQUEST_LIST = preload("res://scripts/systems/gods/RequestList.tres")
const MEMO = preload("res://scenes/memo.tscn")

enum Need {
	ZODIAC,
	TRADE,
	PURITY,
	WEALTH
}

enum Gods {
	OSIRIS,    # good
	ISIS,      # mid
	SET        # bad
}

var god_colors:Array[Color] = [
	Color('#2ea340'),
	Color('#ffa214'),
	Color('#db4949')
]

class God:
	var name:String
	var relationship:int = 10 : 
		set(value):
			if value - relationship > 0:
				GlobalSignals.notification.emit("%s is pleased." % name)
			if value - relationship < 0:
				GlobalSignals.notification.emit("%s will remember this." % name)
			print("%s' relationship updated by %s" % [self.name, value - relationship])
			relationship = value
	var purity_range:Array[float]
	var appeased:bool = false
	
	func _init(name:String, purity_range:Array[float]) -> void:
		self.name = name
		self.purity_range = purity_range

var gods:Array[God] = [God.new("Osiris", [-1, -0.6]), God.new("Isis", [-0.5,0.5]), God.new("Set", [0.5,1])]

func _ready() -> void:
	GlobalSignals.next_person.connect(_on_next_person)

func get_god(god_enum):
	return gods[god_enum]
	
func get_number_of_godes():
	return gods.size()

func receive_person(god:Gods, person:Person):
	person_received.emit(person)

	if person.memos.size() > 0:
		for memo in person.memos:
			if memo.send_to.has(god):
				get_god(memo.from).relationship += 2
			else: get_god(memo.from).relationship -= 2
				
			get_god(memo.from).appeased = true
	check_correct_god(person, god)


func check_correct_god(person:Person, god:Gods):
	var g = get_god(god)
	print("%s was appeased: %s" % [g.name, g.appeased])
	if g.appeased: return
	if person.answer == god:
		g.relationship += 1
	else:
		get_god(person.answer).relationship -= 1
		g.relationship -= 1

func get_relationships() -> Array:
	return gods.reduce(func(accum:Array, god):
		accum.append(god.relationship)
		return accum, [])


func _on_next_person():
	for god in gods:
		god.appeased = false
	print(get_relationships())
