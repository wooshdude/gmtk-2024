extends Sprite2D
@onready var heart_cup: Node2D = $HeartCup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not check_hovered(): return
	if not check_hovered().grabbed:
		check_hovered().global_position = lerp(check_hovered().global_position, heart_cup.global_position, 0.1)


func check_hovered() -> Draggable:
	for o in GrabManager.objects:
		if not o.grabbed and o.type != Draggable.ItemType.HEART: continue
		if (o.position.x > position.x - scale.x*texture.get_width()/2 
		and o.position.x < position.x + scale.x*texture.get_width()/2
		and o.position.y < position.y + scale.y*texture.get_height()/2
		and o.position.y > position.y - scale.y*texture.get_height()/2):
			return o
	return null
