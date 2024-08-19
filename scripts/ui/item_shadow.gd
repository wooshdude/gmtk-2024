extends Sprite2D

@onready var item:Sprite2D = get_parent()

var tween:Tween
var disabled:bool = false:
	set(value):
		if (value != disabled):
			disabled = value
			if tween: tween.stop()
			tween =  create_tween()
			tween.tween_property(self, "modulate:a", 0 if disabled else 1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item.texture_changed.connect(_texture_changed)
	_texture_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _texture_changed():
	texture = item.texture
	
	
