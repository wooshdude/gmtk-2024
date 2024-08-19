extends Sprite2D
class_name Draggable

var shadow_scene = preload("res://scenes/item_shadow.tscn")

@export var return_when_dropped:bool = false
@export var return_after_dropped:bool = false

enum ItemType { HEART, BELONGING, MEMO, FLASHLIGHT, STAMP }
@export var type : ItemType
@export var god : GodManager.Gods

var start_position
var dropped = true
var hovered = false
var grabbed = false:
	set(value):
		grabbed = value
		if (grabbed): dropped = false
@export var disabled = false
@export var weight = 1
var square_distance
var tween:Tween

var shadow:Sprite2D

var pick_animation = [ItemType.HEART, ItemType.STAMP, ItemType.BELONGING]

func _ready() -> void:
	start_position = position
	self.tree_exiting.connect(_on_tree_exiting)
	if self.type == ItemType.HEART: GlobalSignals.stamped.connect(_stamped)
	GrabManager.add_object(self)
	
	if pick_animation.has(self.type) : add_shadow()
	
	if pick_animation.has(self.type) and self.type != ItemType.STAMP:
		disabled = true
		modulate = Color(1, 0.1, 0.1, 0)
		
		if tween: tween.stop()
		tween =  create_tween()
		var delay = randf() * 1
		tween.tween_property(self, "modulate:a", 1, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(delay)
		tween.parallel().tween_property(self, "modulate",  Color(1, 1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.05 + delay)
		await tween.finished
		disabled = false

func _process(delta: float) -> void:
	square_distance = (get_global_mouse_position() - global_position).length_squared()
	z_index = get_grab_z()
	

func _physics_process(delta: float) -> void:
	if return_after_dropped and dropped:
		self.position = lerp(position, start_position,0.3)
	drag()
	check_hovered()
	#print(hovered)


func drag():
	if grabbed and GrabManager.grabbed_object != self:
		var final_position = get_viewport().get_mouse_position()
		if pick_animation.has(self.type) and self.type != ItemType.HEART:
			final_position = get_viewport().get_mouse_position().clamp(GrabManager.get_confines_start(), GrabManager.get_confines_end())
		self.position = lerp(position, final_position,0.3)
		if self.type == ItemType.HEART:
			if Rect2(GrabManager.get_confines_start(),GrabManager.get_confines_size()).has_point(get_viewport().get_mouse_position()):
				shadow.disabled = false
			else: shadow.disabled = true
	else:
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
			match type:
				ItemType.HEART : tween.tween_property(self, "offset", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
				ItemType.STAMP : 
					tween.tween_property(self, "offset", Vector2(0, 4), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
					tween.tween_property(self, "offset", Vector2(randf_range(-2, 2), 2), 0.2).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
					tween.tween_property(self, "offset", Vector2(randf_range(-2, 2), 0), 0.2).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
					tween.tween_property(self, "offset", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
				var default : tween.tween_property(self, "offset", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
			await tween.finished
			dropped = true
			if self.type == ItemType.STAMP and GrabManager.on_heart(self):
				GlobalSignals.stamped.emit(god)
		#GrabManager.grabbed_object = null
		#TODO ADD SFX

func get_grab_z():
	if self.type == ItemType.STAMP:
		return GrabManager.stamp_z
	else:
		if grabbed: return GrabManager.grab_z
		else: return GrabManager.drop_z
	

func check_hovered():
	var gmp = get_global_mouse_position()
	if (gmp.x > position.x - scale.x*texture.get_width()/2 
	and gmp.x < position.x + scale.x*texture.get_width()/2
	and gmp.y < position.y + scale.y*texture.get_height()/2
	and gmp.y > position.y - scale.y*texture.get_height()/2):
		hovered = true
	else:
		hovered = false

func add_shadow():
	shadow = shadow_scene.instantiate()
	add_child(shadow)
	shadow.global_position.y += 3

func remove():
	disabled = true
	if tween: tween.stop()
	tween =  create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _stamped(god):
	if tween: tween.stop()
	tween =  create_tween()
	tween.tween_property(self, "position:y", 256, 0.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT).set_delay(0.5)
	

func _on_tree_exiting():
	GrabManager.remove_object(self)
	pass
