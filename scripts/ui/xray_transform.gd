extends Node2D

var elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed = wrap(elapsed + delta, 0, 2*PI)
	var breath = remap(sin(elapsed*2), -1, 1, 1.0, 1.2)
	scale = Vector2.ONE * breath
	global_position = get_global_mouse_position()
