extends Node2D
class_name draggable

@onready var TEXTURE = get_node("TextureButton")

enum objects { HEART, BELONGING, MEMO, FLASHLIGHT }
@export var type : objects


var hovered = false
var grabbed = false


func _ready():
	TEXTURE = get_node("TextureButton")
	TEXTURE.set_anchors_preset(Control.PRESET_CENTER)
	
func _physics_process(delta: float) -> void:
	drag()
	check_hovered()

func drag():
	
	if grabbed:
		self.position = get_viewport().get_mouse_position()
	
	if self.hovered and Input.is_action_just_pressed("CLICK"):
		grabbed = true
		#TODO ADD SFX
	if self.grabbed and Input.is_action_just_released("CLICK"):
		grabbed = false
		#TODO ADD SFX

func check_hovered():
	if TEXTURE.is_hovered():
		hovered = true
	else:
		hovered = false
