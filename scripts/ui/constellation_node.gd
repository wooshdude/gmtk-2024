extends Sprite2D

var elapsed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed = wrap(elapsed + delta, 0, 2*PI)
	var wave = sin(elapsed*2)
	var wave2 = sin(elapsed*2 + PI/2) 
	skew = wave * PI/12
	offset.x = wave2
