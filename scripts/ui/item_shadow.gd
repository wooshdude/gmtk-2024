extends Sprite2D

@onready var item:Sprite2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item.texture_changed.connect(_texture_changed)
	_texture_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _texture_changed():
	texture = item.texture
	scale = item.scale
	rotation = item.rotation
	
	
