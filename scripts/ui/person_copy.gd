extends AnimatedSprite2D

@onready var person_texture: AnimatedSprite2D = $"../PersonTexture"
@onready var person: PersonNode = $".."
@onready var xray_insides: BackBufferCopy = $XrayInsides

func _ready() -> void:
	play("default")
	sprite_frames = person_texture.sprite_frames
	person_texture.sprite_frames_changed.connect(_on_texture_changed)
	show()
	
func _process(delta: float) -> void:
	offset = person_texture.offset
	if person.xray is Node2D and person.xray.disabled:
		person_texture.material.set_shader_parameter("enabled", 0)
	else:
		person_texture.material.set_shader_parameter("enabled", 1)
	offset = person_texture.offset

func _on_texture_changed():
	sprite_frames = person_texture.sprite_frames
	
	
