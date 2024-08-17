shader_type canvas_item;
uniform sampler2D scre : hint_screen_texture;
uniform vec2 offset;
uniform vec2 scale;
uniform float angle;
varying vec2 tempUV;

void vertex() {
	UV -= vec2(0.5);
	tempUV = UV;
	
	float cosA = cos(angle);
	float sinA = sin(angle);
	mat2 transformMatrix = mat2(vec2(cosA, -sinA), vec2(sinA,  cosA));
	
	UV = transformMatrix * UV;
	UV /= scale;
	
	UV += vec2(0.5);
	
	UV -= (mat2(vec2(cosA, -sinA), vec2(sinA,  cosA)) *offset)/scale;
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
