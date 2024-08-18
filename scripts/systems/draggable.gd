extends Sprite2D
class_name Draggable

@export var return_when_dropped:bool = false
var start_position

enum objects { HEART, BELONGING, MEMO, FLASHLIGHT }
@export var type : objects

var hovered = false
var grabbed = false


func _ready() -> void:
	start_position = position
	GrabManager.add_object(self)
	self.tree_exiting.connect(_on_tree_exiting)


func _physics_process(delta: float) -> void:
	drag()
	check_hovered()
	#print(hovered)


func drag():
	if grabbed and GrabManager.grabbed_object != self:
		self.position = lerp(position, get_viewport().get_mouse_position(),0.3)
		z_index = 2
	else:
		z_index = 1   
		if return_when_dropped:
			self.position = lerp(position, start_position,0.3)
	
	#print(GrabManager.check_can_drag(self))
	if self.hovered and Input.is_action_just_pressed("CLICK"):
		if GrabManager.check_can_drag(self):
			grabbed = true
		#TODO ADD SFX
	if self.grabbed and Input.is_action_just_released("CLICK"):
		grabbed = false
		#TODO ADD SFX


func check_hovered():
	var gmp = get_global_mouse_position()
	if (gmp.x > position.x - scale.x*texture.get_width()/2 
	and gmp.x < position.x + scale.x*texture.get_width()/2
	and gmp.y < position.y + scale.y*texture.get_height()/2
	and gmp.y > position.y - scale.y*texture.get_height()/2):
		hovered = true
	else:
		hovered = false


func _on_tree_exiting():
	GrabManager.remove_object(self)
