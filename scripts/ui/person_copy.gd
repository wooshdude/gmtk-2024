extends AnimatedSprite2D

@onready var person_texture: AnimatedSprite2D = $"../PersonTexture"
@onready var person: PersonNode = $".."
@onready var xray_insides: BackBufferCopy = $XrayInsides

func _ready() -> void:
	play("default")
	sprite_frames = person_texture.sprite_frames
	person_texture.sprite_frames_changed.connect(_on_texture_changed)
	
func _process(delta: float) -> void:
	if person.xray is Node2D:
		xray_insides.visible = not person.xray.disabled

func _on_texture_changed():
	sprite_frames = person_texture.sprite_frames
	
	
