extends Sprite2D
class_name Draggable

var shadow_scene = preload("res://scenes/item_shadow.tscn")

@export var return_when_dropped:bool = false

enum ItemType { HEART, BELONGING, MEMO, FLASHLIGHT, STAMP }
@export var type : ItemType

var start_position
var hovered = false
var grabbed = false
@export var disabled = false
@export var weight = 1
var square_distance
var tween:Tween

var shadow:Sprite2D

var pick_animation = [ItemType.HEART, ItemType.STAMP, ItemType.BELONGING]

func _ready() -> void:
	start_position = position
	GrabManager.add_object(self)
	self.tree_exiting.connect(_on_tree_exiting)
	if pick_animation.has(self.type):
		shadow = shadow_scene.instantiate()
		add_child(shadow)
		shadow.global_position.y += 3
	


func _physics_process(delta: float) -> void:
	square_distance = (get_global_mouse_position() - global_position).length_squared()
	drag()
	check_hovered()
	#print(hovered)


func drag():
	if grabbed and GrabManager.grabbed_object != self:
		var final_position = get_viewport().get_mouse_position()
		if pick_animation.has(self.type) and self.type != ItemType.HEART:
			final_position = get_viewport().get_mouse_position().clamp(GrabManager.get_confines_start(), GrabManager.get_confines_end())
		self.position = lerp(position, final_position,0.3)
		z_index = GrabManager.grab_z
		if self.type == ItemType.HEART:
			if Rect2(GrabManager.get_confines_start(),GrabManager.get_confines_size()).has_point(get_viewport().get_mouse_position()):
				shadow.disabled = false
			else: shadow.disabled = true
	else:
		z_index = GrabManager.drop_z
		if return_when_dropped:
			self.position = lerp(position, start_position,0.3)
	
	#print(GrabManager.check_can_drag(self))
	if self.hovered and Input.is_action_just_pressed("CLICK"):
		if GrabManager.check_can_drag(self):
			grabbed = true
			if pick_animation.has(self.type):
				if tween: tween.stop()
				tween = create_tween()
				tween.tween_property(self, "offset", Vector2(0, -30).rotated(-global_rotation), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			
			#GrabManager.grabbed_object = self
		#TODO ADD SFX
	if self.grabbed and Input.is_action_just_released("CLICK"):
		grabbed = false
		if pick_animation.has(self.type):
			if tween: tween.stop()
			tween = create_tween()
			tween.tween_property(self, "offset", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_SPRING if self.type == ItemType.HEART else Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		#GrabManager.grabbed_object = null
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
