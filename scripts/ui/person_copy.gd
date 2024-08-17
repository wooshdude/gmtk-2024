extends Sprite2D

@onready var person_texture: Sprite2D = $"../PersonTexture"
@onready var person: PersonNode = $".."
@onready var xray_insides: BackBufferCopy = $XrayInsides

func _ready() -> void:
	texture = person_texture.texture
	person_texture.texture_changed.connect(_on_texture_changed)
	
func _process(delta: float) -> void:
	if person.xray is Node2D:
		xray_insides.visible = not person.xray.disabled

func _on_texture_changed():
	texture = person_texture.texture
	
	
