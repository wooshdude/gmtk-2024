shader_type canvas_item;
uniform sampler2D scre : hint_screen_texture;
uniform vec2 offset;

void vertex() {
	UV -= offset;
}

void fragment() {
	
	COLOR = texture(scre, SCREEN_UV);
	COLOR.a = 1.0 - texture(TEXTURE, UV).a;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
