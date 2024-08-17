extends Node2D

@onready var mask_group: CanvasGroup = $MaskGroup
@onready var texture_rect: TextureRect = %XrayBG
var elapsed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed = wrap(elapsed + delta, 0, 2*PI)
	global_position = get_global_mouse_position()
	texture_rect.material.set_shader_parameter("offset", global_position / texture_rect.size.x)
