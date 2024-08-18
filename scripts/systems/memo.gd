extends Draggable
class_name Memo

@export var request_time : float = 10.0 # Adjusts the amount of time a request stays on screen
@onready var content: RichTextLabel = $Control/RichTextLabel

var rng = RandomNumberGenerator.new()


var gods = ["Joe", "Ballsack", "Osiris", "Saint-14", "Riven", "Savathun"] ##TODO change ENUMS to match player's enums
enum stats { WEIGHT, SIGN, BELONGINGS, TRADE, WEALTH }
enum signs { SOLAR, ARC, VOID, STASIS, STRAND }

var request : Dictionary :
	set(value):
		request = value
		content.text = value["text"]

var request_completed = false


func _ready():
	super()
	self.type = objects.MEMO
	#TODO ADD SPAWN IN SFX
	request_timeout()
	print(request)
	position = Vector2(randf_range(200,350), -texture.get_size().y)
	var new_tween := create_tween()
	new_tween.tween_property(self, "position", Vector2(position.x, 150), 0.5).set_trans(Tween.TRANS_SINE)


func _physics_process(delta: float) -> void:
	super(delta)
	display_request(self.request["text"])
	check_if_completed()
	if self.request_completed:
		delete_request()


func get_request():
	return self.request


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
	GrabManager.remove_object(self)
	self.queue_free()
	
	
