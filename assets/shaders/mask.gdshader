shader_type canvas_item;
uniform sampler2D mask;
uniform vec2 offset;
uniform vec2 scale;
uniform float angle;
uniform int sheet_columns = 1;
uniform int sheet_rows = 1;
uniform float enabled : hint_range(0.0,1.0) = 1;
varying vec2 tempUV;
varying vec2 UV2;


void fragment() {

	vec2 sprite_sheet_size = vec2(textureSize(TEXTURE,0));
	vec2 frame_size;
	frame_size.x = sprite_sheet_size.x/float(sheet_columns);
	frame_size.y = sprite_sheet_size.y/float(sheet_rows);
	vec4 texture_color = texture(TEXTURE, UV);
	vec2 current_point = sprite_sheet_size * UV;
	float row = floor(current_point.y / frame_size.y);
	float column = floor(current_point.x / frame_size.x);
	vec2 max_point = (frame_size * vec2(column, row)) + frame_size;
	UV2 = 1.0 - (max_point - current_point) / frame_size;

	UV2 -= vec2(0.5);

	float cosA = cos(angle);
	float sinA = sin(angle);
	mat2 transformMatrix = mat2(vec2(cosA, -sinA), vec2(sinA,  cosA));

	UV2 = transformMatrix * UV2;
	UV2 /= scale;

	UV2 += vec2(0.5);

	UV2 -= (mat2(vec2(cosA, -sinA), vec2(sinA,  cosA)) *offset)/scale;

	COLOR.a = (1.0 - enabled * texture(mask, UV2).a) * texture(TEXTURE, UV).a;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
