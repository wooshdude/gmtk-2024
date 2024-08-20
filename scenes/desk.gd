extends Node2D
@onready var sound_component: SoundComponent = $SoundComponent
@onready var flashlight: Draggable = $Flashlight
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const PERSON = preload("res://scenes/person.tscn")
var imprint_scene = preload("res://scenes/imprint.tscn")
@export var people_list:PeopleList
@export var xray:Node2D
@export var confines:Sprite2D
var allow_judgement:bool = false:
	get:
		var allow = allow_judgement
		if allow_judgement:
			allow_judgement = false
		return allow

var current_person:PersonNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(0,0,0,1)
	var new_tween := create_tween()
	new_tween.tween_property(self, "modulate", Color(1,1,1,1),0.5)
	GlobalSignals.next_person.connect(_on_next_person)
	GlobalSignals.next_person.emit()
	GlobalSignals.person_ready.connect(_on_person_ready)
	GlobalSignals.stamped.connect(_on_stamped)
	GrabManager.confines = confines
	flashlight.is_grabbed.connect(_on_flashlight_grabbed)
	flashlight.is_dropped.connect(_on_flashlight_dropped)
	GlobalSignals.stamping.connect(_on_stamping)
	await new_tween.finished
	audio_stream_player.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_flashlight_grabbed():
	sound_component.play("flashlight_grab")

func _on_flashlight_dropped():
	sound_component.play("flashlight_drop")

func _on_stamping():
	await get_tree().create_timer(0.5).timeout
	sound_component.play("stamp")

func _on_next_person():
	var new_person := PERSON.instantiate()
	var new_person_data := people_list.get_next_person()
	if new_person_data:
		new_person.person_data = new_person_data
		new_person.xray = xray
		
		self.add_child(new_person)
		current_person = new_person
	else:
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(0,0,0,1), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		get_tree().change_scene_to_file("res://scenes/results.tscn")

func _on_person_ready():
	allow_judgement = true

func _on_stamped(god):
	if(allow_judgement):
		if god == GodManager.Gods.SET:
			GlobalSignals.damn.emit()
		else:
			GlobalSignals.dismiss.emit()
		GodManager.receive_person(god, current_person.person_data)
		var imprint:AnimatedSprite2D = imprint_scene.instantiate()
		GrabManager.heart.add_child(imprint)
		imprint.frame = god
		imprint.modulate = GodManager.god_colors[god]
		imprint.position = Vector2.ZERO
		

#func _on_good_button_pressed() -> void:
	#print('good')
	#if(allow_judgement):
		#GlobalSignals.dismiss.emit()
		#GodManager.receive_person(GodManager.Gods.OSIRIS, current_person.person_data)
#
#
#func _on_mid_button_pressed() -> void:
	#if(allow_judgement):
		#GlobalSignals.dismiss.emit()
		#GodManager.receive_person(GodManager.Gods.ISIS, current_person.person_data)
#
#
#func _on_bad_button_pressed() -> void:
	#if(allow_judgement):
		#GlobalSignals.damn.emit()
		#GodManager.receive_person(GodManager.Gods.SET, current_person.person_data)


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.playing = true
