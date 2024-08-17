shader_type canvas_item;

uniform float speed;
uniform vec2 direction;
uniform vec2 offset;

void vertex() {
	UV += (direction * speed * TIME) + offset;
}
