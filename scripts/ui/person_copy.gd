extends Sprite2D

@onready var person_texture: Sprite2D = $"../PersonTexture"

func _ready() -> void:
	texture = person_texture.texture
	person_texture.texture_changed.connect(_on_texture_changed)

func _on_texture_changed():
	texture = person_texture.texture
	
	
