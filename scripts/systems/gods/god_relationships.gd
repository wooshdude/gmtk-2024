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

class God:
	var name:String
	var relationship:int = 10 : 
		set(value):
			if value - relationship > 0:
				GlobalSignals.notification.emit("%s is pleased." % name)
			if value - relationship < 0:
				GlobalSignals.notification.emit("%s will remember this." % name)
			print("%s' relationship updated by %s" % [self.name, value - relationship])
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


func receive_person(god:Gods, person:Person):
	person_received.emit(person)

	if person.memos.size() > 0:
		for memo in person.memos:
			get_god(memo.from).appeased = true
			for m in memo.send_to:
				if god == m:
					get_god(memo.from).relationship += 2
					break;
				
				get_god(memo.from).relationship -= 2
	check_correct_god(person, god)


func check_correct_god(person:Person, god:Gods):
	var g = get_god(god)

	if g.appeased: return
	if person.answer == god:
		g.relationship += 1
	else:
		get_god(person.answer).relationship -= 1
		g.relationship -= 1


func _on_next_person():
	for god in gods:
		god.appeased = false
