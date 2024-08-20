extends Sprite2D
class_name AnimatedScale
@onready var fulcrum: Sprite2D = $Fulcrum
@onready var heart_cup: Node2D = $Fulcrum/CupR/HeartCup
@onready var feather: Sprite2D = $Fulcrum/CupL/Feather
@export var fall_curve: Curve
var weighing = false
var tween:Tween


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for cup:Sprite2D in fulcrum.get_children():
		cup.global_rotation = 0
	
	if not check_hovered(): 
		if weighing:
			weighing = false
			if !!tween: tween.stop() 
			tween = create_tween()
			tween.tween_property(fulcrum, "rotation", 0, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			tween.parallel().tween_property(feather, "modulate:a", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		return
	if not check_hovered().grabbed:
		var o = check_hovered()
		o.global_position = lerp(o.global_position, heart_cup.global_position, 0.1)
		if not weighing:
			weighing = true
			if !!tween: tween.stop() 
			tween = create_tween()
			var weight
			tween.tween_property(fulcrum, "rotation", atan(o.weight), 1).set_ease(Tween.EASE_OUT).set_custom_interpolator(fall_curve.sample)
			tween.parallel().tween_property(feather, "modulate:a", 1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	elif weighing:
		weighing = false
		if !!tween: tween.stop() 
		tween = create_tween()
		tween.tween_property(fulcrum, "rotation", 0, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(feather, "modulate:a", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func check_hovered() -> Draggable:
	for o in GrabManager.objects:
		if not o.grabbed and o.type != Draggable.ItemType.HEART: continue
		if (o.position.x > position.x - scale.x*texture.get_width()/2 
		and o.position.x < position.x + scale.x*texture.get_width()/2
		and o.position.y < position.y + scale.y*texture.get_height()/2
		and o.position.y > position.y - scale.y*texture.get_height()/2):
			return o
	return null
