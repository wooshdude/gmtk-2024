extends AnimatedSprite2D
@onready var person: PersonNode = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if person.xray is Node2D:
		to_local(person.xray.global_position)
		material.set_shader_parameter("offset", to_local(person.xray.global_position)/(get_sprite_frames().get_frame_texture(animation, frame).get_size()*global_scale))
		material.set_shader_parameter("scale", person.xray.scale*global_scale*0.25)
		material.set_shader_parameter("angle", person.xray.rotation - global_rotation)
		material.set_shader_parameter("sheet_columns", self.sprite_frames.get_frame_count(animation))
		print(get_sprite_frames().get_frame_texture(animation, frame).get_size())
