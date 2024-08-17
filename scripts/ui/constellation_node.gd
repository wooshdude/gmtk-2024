extends AnimatedSprite2D

var elapsed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Animation stuff
	elapsed = wrap(elapsed + delta, 0, 2*PI)
	var skew_wave = sin(elapsed*2)
	var offset_x_wave = sin(elapsed*2 + PI/2)
	var offset_y_wave = sin(elapsed*14)
	var opacity_wave = remap(cos(elapsed*3 + PI/3), -1, 1, 0.2, 0.7)
	skew = skew_wave * PI/12
	offset = Vector2(offset_x_wave, offset_y_wave * 0.4)
	modulate.a = opacity_wave
